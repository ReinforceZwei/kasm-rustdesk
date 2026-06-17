FROM kasmweb/core-ubuntu-jammy:1.17.0
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

RUN  TEMP_DEB="$(mktemp).deb" \
    && add-apt-repository ppa:pipewire-debian/pipewire-upstream \
    && apt-get -f install libxcb-randr0 libxdo3 gstreamer1.0-pipewire -y\
    && LATESTURL="$(curl -f -L https://github.com/rustdesk/rustdesk/releases/latest | grep -Eo 'https://[a-zA-Z0-9#~.*,/!?=+&_%:-]*-x86_64.deb')" \
    && wget -O $TEMP_DEB $LATESTURL \
    && apt install -f $TEMP_DEB -y\
    && rm -f "$TEMP_DEB"

RUN echo "/usr/bin/desktop_ready && /usr/bin/rustdesk &" > $STARTUPDIR/custom_startup.sh \
    && chmod +x $STARTUPDIR/custom_startup.sh

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000