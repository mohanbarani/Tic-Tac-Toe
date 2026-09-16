# Tic-Tac-Toe on EKS — full pipeline reference

Source game: https://github.com/mohanbarani/Tic-Tac-Toe (Tkinter desktop app).

This project wraps it with `Xvfb` + `x11vnc` + `noVNC` so it runs headless
inside a container and is reachable from a browser on port `6080`, which
lets it slot into a normal EKS + LoadBalancer pipeline like a web app would.

## Files

- `main.py` — the original game logic (unmodified)
- `requirements.txt` — Python deps (`numpy`)
- `Dockerfile` — builds the headless, browser-viewable image
- `supervisord.conf` — runs Xvfb, fluxbox, the game, x11vnc, and noVNC together
- `deployment.yaml` / `service.yaml` — Kubernetes manifests (Service type
  `LoadBalancer`, mapping port 80 → container port 6080)

## Run locally with Docker

```bash
docker build -t tictactoe .
docker run -p 6080:6080 tictactoe
```

Open `http://localhost:6080/vnc.html`, click **Connect**, and play.

## Deploy to EKS

Update the image line in `deployment.yaml` with your ECR URI, then:

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl get pods
kubectl get svc tictactoe-service
```

Once `EXTERNAL-IP` is assigned, open `http://<external-ip>/vnc.html`.
