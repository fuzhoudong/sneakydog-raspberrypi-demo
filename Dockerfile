FROM balenalib/raspberry-pi-debian-python

WORKDIR /user/src/app

COPY . .

RUN echo python --version

RUN apt update && apt-get install wget gnupg -y 
RUN cp raspi.list /etc/apt/sources.list.d 
RUN wget -O raspi.key https://archive.raspberrypi.com/debian/raspberrypi.gpg.key
RUN apt-key add raspi.key 
RUN apt update

RUN apt install -y python3-libcamera python3-kms++
RUN apt install -y python3-prctl libatlas-base-dev ffmpeg libopenjp2-7
RUN pip install numpy --upgrade
RUN pip install picamera2


RUN pip install --no-cache-dir -r requirements.txt
RUN pip install build && python -m build
RUN pip install ./dist/*.whl

EXPOSE 5000

ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_DEBUG=0
ENV FLASK_APP=sneakydog_raspberrypi_demo

CMD ["flask", "run"]
