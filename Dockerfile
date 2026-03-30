FROM python:3.11-slim
# Set working directory
WORKDIR /app
# Copy python file
COPY app.py .
# Run the script
CMD ["python", "app.py"]
