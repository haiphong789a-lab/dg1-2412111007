FROM python:3.11-slim

WORKDIR /usr/src/app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN useradd -m appuser

COPY app/ ./app/
RUN chown -R appuser:appuser /usr/src/app

USER appuser

ENV PORT=5000
EXPOSE 5000

CMD ["python", "app/app.py"]
