# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

umask 022

export IBUS_ENABLE_SYNC_MODE=1

export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.161-0.b14.el7_4.x86_64
export WILDFLY_HOME=/usr/share/ovirt-engine-wildfly

export OVIRT_SRC=/vagrant/ovirt-engine
export OVIRT_OUT=$HOME/build/ovirt-engine

# oVirt Engine development
engine_runTests=0
engine_buildGwt=1
engine_gwtUserAgent='gecko1_8,safari'
engine_gwtDraftCompile=1
engine_gwtLogLevel='INFO'
engine_gwtLocale='en_US'
engine_gwtWorkers=1
engine_gwtSuperDev=0
engine_jbossHome=$WILDFLY_HOME
engine_extraMakeParams=''

function engine() {
    case $1 in
        make)
            # Pre-build actions
            if [[ "$engine_jbossHome" != "$WILDFLY_HOME" ]]; then
                engine_extraMakeParams="$engine_extraMakeParams WILDFLY_OVERLAY_MODULES=''"
            fi
            rm -rf $OVIRT_OUT/share/ovirt-engine/engine.ear/*
            rm -rf $OVIRT_OUT/share/ovirt-engine/gwt-symbols/*
            # rm -rf $OVIRT_OUT/packaging/dbscripts/upgrade/*
            # Build Engine for development
            cd $OVIRT_SRC
            make clean install-dev PREFIX="$OVIRT_OUT" JBOSS_HOME="$engine_jbossHome" \
                BUILD_UT=$engine_runTests \
                BUILD_GWT=$engine_buildGwt \
                DEV_EXTRA_BUILD_FLAGS_GWT_DEFAULTS="-Dgwt.userAgent=$engine_gwtUserAgent" \
                DEV_EXTRA_BUILD_FLAGS="-Dgwt.logLevel=$engine_gwtLogLevel -Dgwt.locale=$engine_gwtLocale -Dgwt.compiler.localWorkers=$engine_gwtWorkers" \
                DEV_BUILD_GWT_DRAFT=$engine_gwtDraftCompile \
                DEV_BUILD_GWT_SUPER_DEV_MODE=$engine_gwtSuperDev \
                $engine_extraMakeParams
            # Post-build actions
            echo "JAVA_HOME=$JAVA_HOME" > $OVIRT_OUT/etc/ovirt-engine/engine.conf.d/99-setup-java.conf
            echo "DASHBOARD_CACHE_UPDATE=false" > $OVIRT_OUT/etc/ovirt-engine/engine.conf.d/99-no-dashboard.conf
            ;;
        setup)
            $OVIRT_OUT/bin/engine-setup --jboss-home="${engine_jbossHome}"
            ;;
        run)
            $OVIRT_OUT/share/ovirt-engine/services/ovirt-engine/ovirt-engine.py start
            ;;
        debug)
            cd $OVIRT_SRC
            make gwt-debug \
                DEV_EXTRA_BUILD_FLAGS_GWT_DEFAULTS="-Dgwt.userAgent=$engine_gwtUserAgent" \
                DEV_EXTRA_BUILD_FLAGS="-Dgwt.logLevel=$engine_gwtLogLevel -Dgwt.locale=$engine_gwtLocale -Dgwt.compiler.localWorkers=$engine_gwtWorkers" \
                DEV_BUILD_GWT_SUPER_DEV_MODE=$engine_gwtSuperDev \
                $engine_extraMakeParams
            ;;
        vdsmfake)
            cd $HOME/work/ovirt-vdsmfake
            mvn wildfly-swarm:run -D maven.test.skip
            ;;
    esac
}
