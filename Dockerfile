FROM python:3.9-alpine

WORKDIR /app

COPY requirements.txt .

RUN python -m venv /venv

ENV PATH="/venv/bin:$PATH"

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "app.py"]

EXPOSE 8088
