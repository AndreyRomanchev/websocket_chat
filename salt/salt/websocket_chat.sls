websocket_chat:
  docker_container.running:
    - image: timka/websocket_chat:latest
    - publish: "8080:8080"
    - restart: always
  require:
    - pip: docker-py
