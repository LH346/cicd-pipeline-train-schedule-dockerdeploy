FROM node:carbon as builder
WORKDIR /usr/app
COPY . /usr/app
RUN npm install

FROM node:carbon-alpine
WORKDIR /usr/prod/
COPY --from=builder /usr/app ./
EXPOSE 8080
CMD ["npm", "start"]




