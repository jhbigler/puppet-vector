# Changelog

All notable changes to this project will be documented in this file.

## Release 0.1.3

**Features**
* vector::source, vector::transform, and vector::sink types are dumped into their own directories: ${vector::config_dir}/configs/{sources, transforms,sinks}/${title}.${format} respectively. vector::configfile types are saved into ${vector::config_dir}/configs/${title}.${file_format}

**Bugfixes**
* Accidently put the upper version limit for stdlib at 6.0 in previous versions of this module. Removed that upper limit here.

**Known Issues**

## Release 0.1.4

**Features**

**Bugfixes**
* This module did not properly remove unmanaged vector config files in 0.1.3, that is fixed

**Known Issues**

