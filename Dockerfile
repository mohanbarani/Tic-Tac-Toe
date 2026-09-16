# Option B: Run the Tkinter app headlessly inside a virtual display (Xvfb),
# and expose it to a browser via noVNC. This makes the app reachable over
# a normal HTTP port, so it fits into an EKS + LoadBalancer pipeline.
#
#   docker build -t tictactoe-web .
#   docker run -p 6080:6080 tictactoe-web
#   Open http://localhost:6080/vnc.html in a browser

FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-tk \
    xvfb \
    x11vnc \
    fluxbox \
    novnc \
    websockify \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# noVNC's web port
EXPOSE 6080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
