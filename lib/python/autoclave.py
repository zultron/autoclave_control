import os, sys, yaml, datetime


class ConfigError(RuntimeError):
    pass

class Config(object):
    default_base_name = 'config.yaml'
    default_state_file = 'saved_state.yaml'
    default_rrd_file = 'logger.rrd'
    default_rrd_image_dir = 'rrd'
    default_bb_bbio_file = 'etc/overlay-bb.bbio'
    default_share_dir = '.'

    def __init__(self, config_file=None):
        paths = (
            config_file,
            os.environ.get('AUTOCLAVE_CONFIG',None),
            os.path.join(os.path.dirname(__file__),'..','..','etc'),
            '/etc/autoclave')
        for path in paths:
            if path is None:
                continue
            if os.path.isfile(path):
                config_file = path
                break
            path = os.path.abspath(os.path.join(path, self.default_base_name))
            if os.path.isfile(path):
                config_file = path
                break
        if config_file is None:
            raise ConfigError(
                "Unable to locate configuration file '%s'; searched %s" %
                (self.default_base_name, ", ".join(paths)))

        try:
            with open(config_file, 'r') as f:
                self.config = yaml.load(f)
        except Exception as e:
            raise ConfigError(
                "Unable to load configuration file '%s': '%s'" %
                (config_file, e))
        self.config_file = config_file

        Messages.info("Using configuration from %s" % self.config_file)

        # Set $PATH
        if 'PATH' in self.config:
            os.environ['PATH'] = '%s:%s' % \
                                 (self.config['PATH'], os.environ['PATH'])
        # Set $HALDIR
        os.environ['HALDIR'] = self.haldir

    @property
    def haldir(self):
        if 'HALDIR' in self.config:
            path = self.config['HALDIR']
        else:
            path = './hal'
        return os.path.abspath(path)

    def halfilepath(self, base_fname):
        path = os.path.join(self.haldir, base_fname)
        if not os.path.isfile(path):
            raise ConfigError("Unable to locate HAL file '%s'" % base_fname)
        return os.path.abspath(path)
    
    @property
    def state_file(self):
        path = self.config.get('state_file',self.default_state_file)
        return os.path.abspath(path)

    def state_file_exists(self):
        if not os.path.isfile(self.state_file):
            Messages.info('Warning:  State file "%s" does not exist' %
                          self.state_file)
            return False
        else:
            return True

    def write_state(self, comp, param_list):
        old_config = self.read_state()
        new_config = old_config.copy()
        for param in param_list:
            new_config[param] = comp[param]
        if old_config != new_config:
            changed_list = ["%s=%s" % (k,v) for k,v in new_config.items()
                            if old_config[k] != new_config[k]]
            Messages.info("Updating saved state:  %s" % ";".join(changed_list))
            tmp = "%s.tmp" % self.state_file
            with open(tmp, 'w') as f:
                yaml.dump(new_config, f, default_flow_style=False)
            os.rename(tmp, self.state_file)
        #else: Messages.info("State unchanged; not writing")

    def read_state(self):
        if not self.state_file_exists():
            Messages.info("State file missing: '%s'; zeroing data" %
                          self.state_file)
            return {}
        with open(self.state_file, 'r') as f:
            #Messages.info("Using state file '%s'" % self.state_file)
            state = yaml.load(f)
            if not state:
                state = {}
        #Messages.info("Read state %s" % (state,))
        return state

    @property
    def rrd_file(self):
        path = self.config.get('rrd_file', self.default_rrd_file)
        return os.path.abspath(path)

    @property
    def rrd_image_dir(self):
        path = self.config.get('rrd_image_dir', self.default_rrd_file)
        return os.path.abspath(path)
    
    @property
    def bb_bbio_file(self):
        path = self.config.get('bb_bbio_file', self.default_bb_bbio_file)
        return os.path.abspath(path)
    
    @property
    def share_dir(self):
        path = self.config.get('share_dir', self.default_share_dir)
        return os.path.abspath(path)



class Messages(object):
    config = {}

    def __init__(self, name):
        self.config['name'] = name

    @classmethod
    def info(cls, msg):
        sys.stderr.write(
            "%s %s:  %s\n" %
            (str(datetime.datetime.now()),
             cls.config.get('name','Unknown'),
             msg))

    @classmethod
    def warning(cls, msg):
        sys.stderr.write(
            "%s %s WARNING:  %s\n" %
            (str(datetime.datetime.now()),
             cls.config.get('name','Unknown'),
             msg))

    @classmethod
    def error(cls, msg):
        sys.stderr.write(
            "%s %s:  %s\n" %
            (str(datetime.datetime.now()),
             cls.config.get('name','Unknown'),
             msg))
        sys.exit(1)
