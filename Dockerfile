FROM ubuntu:bionic

LABEL version="42"

ENV color_prompt yes
ENV SHELL /bin/bash
ENV TERM xterm-color
ENV NO_PROXY 127.0.0.1
ENV no_proxy 127.0.0.1


RUN apt-get update -q
RUN apt-get install apt-utils locales iputils-ping iputils-arping iputils-tracepath -y
RUN apt-get install mc nano vim curl wget -y
RUN apt-get install build-essential -y
RUN apt-get install git subversion -y


# Installing latest GO (go1.12.5)
RUN cd /tmp && echo "go1.12.5" > $HOME/.go_version &&  \
    wget -q https://storage.googleapis.com/golang/getgo/installer_linux && \
    chmod +x installer_linux && \
    ./installer_linux && \
    . /root/.bash_profile && \
    rm /tmp/installer_linux


# Installing & setting up Python3
RUN apt-get install python3 python3-setuptools python3-virtualenv python3-venv python3-pip -y
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /usr/bin/pip3 /usr/bin/pip
RUN pip install ipdb ipython


# Installing AWS CLI and SDK, OCI CLI and SDK
RUN pip install oci-cli awscli boto3


# Installing Latest Ansible (v2.8.0)
RUN cd /tmp && \
    git clone -q https://github.com/ansible/ansible.git -b "v2.8.0" --single-branch --depth 1 && \
    cd /tmp/ansible && python setup.py build install && rm -rf /tmp/ansible


# Installing Latest Hashicorp Terraform (v0.12.18)
RUN curl -s https://releases.hashicorp.com/terraform/0.12.18/terraform_0.12.18_linux_amd64.zip > terraform_0.12.18_linux_amd64.zip && \
    unzip terraform_0.12.18_linux_amd64.zip -d /bin && \
    rm -f terraform_0.12.18_linux_amd64.zip


# Installing Latest Hashicorp Packer (v1.5.1)
RUN cd /tmp \
    && wget -q https://releases.hashicorp.com/packer/1.5.1/packer_1.5.1_linux_amd64.zip \
    && unzip packer_1.5.1_linux_amd64.zip \
    && mv packer /usr/local/bin/ \
    && rm -rf packer_1.5.1_linux_amd64.zip


ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN locale-gen

COPY scripts/.bashrc /root
COPY scripts/.bashrc_orig /root

RUN chmod 600 /root/.bashrc /root/.bashrc_orig

CMD ["/bin/bash"]
