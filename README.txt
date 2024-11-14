

docker build -f Dockerfile.txt -t universidad .


docker run -d -p 8118:80 -p 2222:22 --name consultau universidad



1.-   http://localhost:8118