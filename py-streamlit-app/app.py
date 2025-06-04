""".

# Welcome to Streamlit!

Edit `/streamlit_app.py` to customize this app to your heart's desire :heart:.
If you have any questions,
checkout our [documentation](https://docs.streamlit.io)
and [community forums](https://discuss.streamlit.io).

In the meantime, below is an example of what you can do with
just a few lines of code:
"""

import logging
import uuid

import altair as alt
import numpy as np
import pandas as pd
import streamlit as st

# Configure logging
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s"
)

# Assign a session ID once per user
if "session_id" not in st.session_state:
    st.session_state.session_id = str(uuid.uuid4())
    logging.info(f"Session started - session_id={st.session_state.session_id}")

st.title("Interactive Spiral Plot")

# Log slider interaction
num_points = st.slider("Number of points in spiral", 1, 10000, 1100)
num_turns = st.slider("Number of turns in spiral", 1, 300, 31)
logging.info(
    f"Slider updated - session_id={st.session_state.session_id} "
    f"num_points={num_points} num_turns={num_turns}"
)

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

# Log chart display
logging.info(
    f"Rendering chart - session_id={st.session_state.session_id} "
    f"data_points={len(df)}"
)

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

# Optional: Log button click
if st.button("Log an event"):
    logging.info(f"Button clicked - session_id={st.session_state.session_id}")
