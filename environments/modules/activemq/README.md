ActiveMQ provisioning module
============================
ActiveMQ is installed by a RPM-package provided by local Yum repository (module *yumrepo*).

Package installs into 

	/opt/apache-activemq-$VERSION
	
and makes symlinks

	/opt/apache-activemq -> /opt/apache-activemq-$VERSION
	/etc/init.d/apache-activemq -> /opt/apache-activemq/bin/activemq
	
Provisioning module does not start default configured broker.

The module contains configuration for two brokers

* integration
* integration-dlq

which is both automaticly started on system startup. Configuration consist of e separate broker home directory for each broker:

	integration -> /var/lib/activemq/activemq-instance-integration
	integration-dlq -> /var/lib/activemq/activemq-instance-integration-dlq 
	
A configuration file for each broker is also placed in `/etc/default`:

	/etc/default/activemq-instance-integration	/etc/default/activemq-instance-integration-dlq
	
where each configuration points to broker home directory. Corresponding symlinks for each broker is placed in `/etc/init.d`:

	/etc/init.d/activemq-instance-integration -> /opt/apache-activemq/bin/activemq	
	/etc/init.d/activemq-instance-integration-dlq -> /opt/apache-activemq/bin/activemq

In each broker home directory a more detailed configuration resists (`conf`). In `conf/activemq` broker name and ports are configured and in `conf/jetty.xml`  Jolokia port is changed. Configured as:

*1st broker:* 

* Name: **integration**
* Transport Connector: **OpenWire** 
* Port: **61617**
* Jolokia port: **8161** 

*2nd broker*:

* Name: **integration-dlq**
* Transport Connector: **OpenWire** 
* Port: **61618**
* Jolokia port: **8162** 