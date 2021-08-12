FROM gradle:latest as builder
WORKDIR /usr/app
COPY . /usr/app
RUN ./gradlew build

FROM node:carbon-alpine
WORKDIR /usr/prod/
COPY --from=builder /usr/app ./
EXPOSE 8080
CMD ["npm", "start"]




