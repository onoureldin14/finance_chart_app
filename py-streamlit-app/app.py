""".

# Welcome to Streamlit!

Edit `/streamlit_app.py` to customize this app to your heart's desire :heart:.
If you have any questions,
checkout our [documentation](https://docs.streamlit.io)
and [community forums](https://discuss.streamlit.io).

In the meantime, below is an example of what you can do with
just a few lines of code:
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

# Assign a session ID once per user
if "session_id" not in st.session_state:
    st.session_state.session_id = str(uuid.uuid4())
    logger.info("Session started", extra={"session_id": st.session_state.session_id})

st.title("Interactive Spiral Plot")

# Log slider interaction
num_points = st.slider("Number of points in spiral", 1, 10000, 1100)
num_turns = st.slider("Number of turns in spiral", 1, 300, 31)
logger.info("Slider updated", extra={"session_id": st.session_state.session_id})

# Compute spiral
indices = np.linspace(0, 1, num_points)
theta = 2 * np.pi * num_turns * indices
radius = indices

x = radius * np.cos(theta)
y = radius * np.sin(theta)

df = pd.DataFrame(
    {
        "x": x,
        "y": y,
        "idx": indices,
        "rand": np.random.randn(num_points),
    }
)

logger.info("Rendering chart", extra={"session_id": st.session_state.session_id})

# Render the chart
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

# Button for simulated financial analysis
if st.button("Run financial analysis"):
    start_time = time.time()

    # Simulate time-series analysis with variable delay
    simulated_delay = random.uniform(0.5, 3.5)
    time.sleep(simulated_delay)

    end_time = time.time()
    duration = round(end_time - start_time, 3)

    st.success(f"Financial analysis completed in {duration} seconds.")

    logger.info(
        "Financial analysis completed",
        extra={
            "session_id": st.session_state.session_id,
            "duration_seconds": duration,
        },
    )
