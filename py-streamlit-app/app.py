"""Streamlit demo app with builtin Prometheus metrics.
--------------------------------------------------
* Streamlit UI runs on port 8501 (default).
* Prometheus metrics are served on /metrics at port 8000.
"""

import json
import logging
import random
import time
import uuid

import altair as alt
import numpy as np
import pandas as pd
import streamlit as st
from prometheus_client import REGISTRY, Counter, Histogram, start_http_server

# ────────────────────────────────────────────────────────────────────────────────
# PROMETHEUS HELPERS
# ────────────────────────────────────────────────────────────────────────────────


def get_or_create_counter(name: str, documentation: str, labelnames=None):
    # pylint: disable=protected-access
    if name in REGISTRY._names_to_collectors:
        return REGISTRY._names_to_collectors[name]
    return Counter(name, documentation, labelnames or [])


def get_or_create_histogram(name: str, documentation: str, labelnames=None):
    """Return an existing Histogram if it exists, otherwise create and register it."""
    if name in REGISTRY._names_to_collectors:  # pylint: disable=protected-access
        return REGISTRY._names_to_collectors[name]
    return Histogram(name, documentation, labelnames or [])


def start_metrics_server_once(port: int = 8000) -> None:
    """
    Start the /metrics HTTP endpoint exactly once per Python process.
    Streamlit re‑runs this script on every interaction, but the process stays alive,
    so we use a module‑level flag to ensure we bind the port only the first time.
    """
    if getattr(start_metrics_server_once, "_started", False):
        return
    try:
        start_http_server(port)
        start_metrics_server_once._started = True  # type: ignore[attr-defined]
    except OSError:
        # Port probably already in use from previous run; ignore in dev mode.
        pass


# 1️⃣ Start the metrics endpoint (before defining metrics).
start_metrics_server_once(port=8000)

# 2️⃣ Define (or re‑use) Prometheus metrics.
REQUEST_COUNT = get_or_create_counter(
    "streamlit_requests_total",
    "Total Streamlit interactions",
    ["action"],
)
ANALYSIS_DURATION = get_or_create_histogram(
    "financial_analysis_duration_seconds",
    "Financial analysis duration in seconds",
)


# ────────────────────────────────────────────────────────────────────────────────
# JSON STRUCTURED LOGGING (unchanged from your original script)
# ────────────────────────────────────────────────────────────────────────────────
class JsonFormatter(logging.Formatter):
    def format(self, record):
        log_record = {
            "timestamp": self.formatTime(record, self.datefmt),
            "level": record.levelname,
            "message": record.getMessage(),
        }
        if hasattr(record, "session_id"):
            log_record["session_id"] = record.session_id
        if hasattr(record, "duration_seconds"):
            log_record["duration_seconds"] = record.duration_seconds
        return json.dumps(log_record)


handler = logging.StreamHandler()
handler.setFormatter(JsonFormatter())
logger = logging.getLogger()
logger.setLevel(logging.INFO)
logger.handlers = [handler]

# ────────────────────────────────────────────────────────────────────────────────
# STREAMLIT APP
# ────────────────────────────────────────────────────────────────────────────────
# Give each visitor a session‑scoped UUID.
if "session_id" not in st.session_state:
    st.session_state.session_id = str(uuid.uuid4())
    logger.info("Session started", extra={"session_id": st.session_state.session_id})

st.title("Interactive Spiral Plot")

# Two sliders
num_points = st.slider("Number of points in spiral", 1, 10_000, 1_100)
num_turns = st.slider("Number of turns in spiral", 1, 300, 31)
REQUEST_COUNT.labels(action="slider_updated").inc()
logger.info("Slider updated", extra={"session_id": st.session_state.session_id})

# Compute spiral
indices = np.linspace(0, 1, num_points)
theta = 2 * np.pi * num_turns * indices
radius = indices
df = pd.DataFrame(
    {
        "x": radius * np.cos(theta),
        "y": radius * np.sin(theta),
        "idx": indices,
        "rand": np.random.randn(num_points),
    }
)

st.altair_chart(
    alt.Chart(df, height=700, width=700)
    .mark_point(filled=True)
    .encode(
        x=alt.X("x", axis=None),
        y=alt.Y("y", axis=None),
        color=alt.Color("idx", legend=None, scale=alt.Scale()),
        size=alt.Size("rand", legend=None, scale=alt.Scale(range=[1, 150])),
    )
)

# Button triggers simulated analysis
# Button triggers simulated analysis
if st.button("Run financial analysis"):
    REQUEST_COUNT.labels(action="financial_analysis").inc()

    start_time = time.time()
    with ANALYSIS_DURATION.time():
        time.sleep(random.uniform(0.5, 3.5))
    duration = round(time.time() - start_time, 3)

    # 🔍 Log updated metric values
    try:
        analysis_count = REQUEST_COUNT.labels(action="financial_analysis")._value.get()
        duration_sum = ANALYSIS_DURATION._sum.get()
        duration_count = ANALYSIS_DURATION._count.get()
    except Exception:
        analysis_count = duration_sum = duration_count = "unavailable"

    st.success(f"Financial analysis completed in {duration} seconds.")
    logger.info(
        "Financial analysis completed",
        extra={
            "session_id": st.session_state.session_id,
            "duration_seconds": duration,
            "streamlit_requests_total.financial_analysis": analysis_count,
            "financial_analysis_duration_seconds_sum": duration_sum,
            "financial_analysis_duration_seconds_count": duration_count,
        },
    )
