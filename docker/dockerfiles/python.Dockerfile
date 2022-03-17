FROM python:3.8-slim-buster
WORKDIR /app

# Uncomment if you have requirements to install
# COPY requirements.txt requirements.txt
# RUN pip3 install -r requirements.txt

# Copy the entire folder with the following line
# COPY . . 
COPY yourApplication.py yourApplication.py

CMD ["python3", "yourApplication.py"]