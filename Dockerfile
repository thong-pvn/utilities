FROM codercom/code-server:latest

# Environment
ENV HOST=0.0.0.0
ENV CODE_SERVER_PORT=8100
ENV CODE_SERVER_PWD='codeserver'
ENV FLUTTER_PORT=8101

# Install code server
EXPOSE $CODE_SERVER_PORT
ENTRYPOINT ["/usr/bin/env"]
RUN mkdir -p ~/.config/code-server/
RUN echo "\
bind-addr: $HOST:$CODE_SERVER_PORT\n\
auth: password\n\
password: $CODE_SERVER_PWD\n\
cert: false" > ~/.config/code-server/config.yaml
# Install Code extensions
RUN code-server --install-extension dart-code.flutter Dart-Code.dart-code

# Install Flutter
RUN sudo apt-get update
RUN sudo apt-get install -y unzip
# Usually in a normal Linux environment, you should not do that
RUN sudo chmod 777 /opt
RUN git clone https://github.com/flutter/flutter.git /opt/flutter
ENV PATH="/opt/flutter/bin:${PATH}"
RUN echo "export PATH='/opt/flutter/bin:$PATH'" >> ~/.bashrc
RUN flutter channel stable
RUN flutter upgrade
RUN flutter doctor
RUN flutter config --enable-web
EXPOSE $FLUTTER_PORT

RUN echo "alias fr='flutter run -d web-server --web-port $FLUTTER_PORT --web-hostname $HOST'" >> ~/.bashrc 

CMD ["/usr/bin/entrypoint.sh", "."]