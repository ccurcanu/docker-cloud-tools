FROM ubuntu:bionic

LABEL version="{DOCKERFILE_VERSION}"

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


# Installing latest stable Golang Go ({GO_VERSION})
RUN cd /tmp &&  \
    wget -q https://dl.google.com/go/{GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf {GO_VERSION}.linux-amd64.tar.gz && \
    echo "PATH=$PATH:/usr/local/go/bin" >> /etc/environment && \
    echo "GOBIN=$HOME/bin" >> /etc/environment && \
    echo "GOPATH=$HOME/go" >> /etc/environment && \
    rm {GO_VERSION}.linux-amd64.tar.gz


# Installing & setting up Python3
RUN apt-get install python3 python3-setuptools python3-virtualenv python3-venv python3-pip -y
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /usr/bin/pip3 /usr/bin/pip
RUN pip install ipdb ipython


# Installing AWS CLI and SDK, OCI CLI and SDK
RUN pip install oci-cli awscli boto3


# Installing Latest Ansible ({ANSIBLE_VERSION})
RUN cd /tmp && \
    git clone -q https://github.com/ansible/ansible.git -b "{ANSIBLE_VERSION}" --single-branch --depth 1 && \
    cd /tmp/ansible && python setup.py build install && rm -rf /tmp/ansible


# Installing Latest Hashicorp Terraform (v{TERRAFORM_VERSION})
RUN curl -s https://releases.hashicorp.com/terraform/{TERRAFORM_VERSION}/terraform_{TERRAFORM_VERSION}_linux_amd64.zip > terraform_{TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_{TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
    rm -f terraform_{TERRAFORM_VERSION}_linux_amd64.zip


# Installing Latest Hashicorp Packer (v{PACKER_VERSION})
RUN cd /tmp \
    && wget -q https://releases.hashicorp.com/packer/{PACKER_VERSION}/packer_{PACKER_VERSION}_linux_amd64.zip \
    && unzip packer_{PACKER_VERSION}_linux_amd64.zip \
    && mv packer /usr/local/bin/ \
    && rm -rf packer_{PACKER_VERSION}_linux_amd64.zip


ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN locale-gen

COPY scripts/.bashrc /root
COPY scripts/.bashrc_orig /root

RUN chmod 600 /root/.bashrc /root/.bashrc_orig

CMD ["/bin/bash"]
