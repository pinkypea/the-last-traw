FROM python:3.6-slim-buster

WORKDIR /app

COPY ./backend/requirements.txt /app/

RUN pip install -r requirements.txt

COPY ./backend/ /app/

EXPOSE 4000

CMD [ "flask", "run", "--host=0.0.0.0", "--port=4000"]