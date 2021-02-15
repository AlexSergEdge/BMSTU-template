ARG IMAGE=intersystemsdc/iris-community:2020.4.0.524.0-zpm
FROM $IMAGE

USER root
WORKDIR /opt/irisapp
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp

COPY irissession.sh /
RUN chmod +x /irissession.sh 

USER ${ISC_PACKAGE_MGRUSER}

COPY  Installer.cls .
COPY  src src

SHELL ["/irissession.sh"]

RUN \
  do $SYSTEM.OBJ.Load("Installer.cls", "ck") \
  set sc = ##class(App.Installer).setup() \
  do ##class(App.Installer).RestWebApp() \
  do ##class(App.Installer).ModifyIrisapp()

# bringing the standard shell back
SHELL ["/bin/bash", "-c"]
