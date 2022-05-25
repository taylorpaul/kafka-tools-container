# Start with a lightweight Java Container with jdk Kafka supports
FROM openjdk:11-slim

# Add a user for running kafka scripts to kafka user group
# groupadd:
# -r = system account
# useradd:
# --no-log-init = do not add the user to the lastlog and faillog databases
# -g = name of primary group of the new account
# -m = create home directory (/home/kafka) for the user
# -s = set default shell for user (/bin/bash)
RUN groupadd -r kafka && useradd --no-log-init -r -g kafka kafka -ms /bin/bash 

# Set user to new user for remaining commands
USER kafka

# Pull/extract/move kafka scripts
RUN mkdir /home/kafka/kafka_tools && mkdir /home/kafka/tmp
WORKDIR /home/kafka/kafka_tools
ADD https://dlcdn.apache.org/kafka/3.2.0/kafka_2.13-3.2.0.tgz /home/kafka/tmp/kafka.tgz

# Change to Root user, extract and remove tarball, move contents to (~/kafka_tools):
USER root
RUN tar -xzf /home/kafka/tmp/kafka.tgz -C /home/kafka/tmp/ && \
    rm /home/kafka/tmp/kafka.tgz && \
    mv /home/kafka/tmp/kafka*/* /home/kafka/kafka_tools && \ 
    rm -rf /home/kafka/tmp

# Copy start command script over and add kafka group (with kafka user in it) to execute permissions:
COPY start_commands.sh /home/kafka/start_commands.sh
RUN chgrp kafka /home/kafka/start_commands.sh && chmod 650 /home/kafka/start_commands.sh

# Change back to kafka user and add new scripts to PATH
USER kafka
ENV PATH="/home/kafka/kafka_tools/bin:${PATH}"

# Expected that you supply commands from ~/kafka_tools/bin, but if not run this one:
CMD [ "../start_commands.sh" ]
