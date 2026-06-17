FROM python:3.11-slim

# System deps: fluidsynth, ffmpeg (includes ffprobe), wget
RUN apt-get update && apt-get install -y --no-install-recommends \
    fluidsynth \
    ffmpeg \
    wget \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .

# ✅ Download FluidR3 GM SoundFont (reliable mirror)
RUN wget --tries=3 --timeout=60 -O /app/soundfont.sf2 \
    "https://raw.githubusercontent.com/urish/cinto/master/media/FluidR3%20GM.sf2"

ENV PORT=8080
EXPOSE 8080

CMD ["bash", "-lc", "uvicorn main:app --host 0.0.0.0 --port ${PORT}"]
