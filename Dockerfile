FROM python:3.11-slim
WORKDIR /app
COPY app.py .
# Install Flask
RUN pip install flask
EXPOSE 5000
CMD ["python", "app.py"]
