FROM python:3.6-alpine

RUN apk add linux-headers musl-dev gcc jpeg-dev zlib-dev

COPY requirements.txt /
RUN pip install -r /requirements.txt

COPY . /code
WORKDIR /code

CMD ["gunicorn", "-w 4", "-b 0.0.0.0:8000", "server:app"]