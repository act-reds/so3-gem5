deps_config := \
	soo/drivers/Kconfig \
	soo/me/Kconfig \
	soo/Kconfig \
	mm/Kconfig \
	ipc/Kconfig \
	fs/Kconfig \
	apps/Kconfig \
	devices/net/Kconfig \
	devices/input/Kconfig \
	devices/fb/Kconfig \
	devices/rpisense/Kconfig \
	devices/i2c/Kconfig \
	devices/irq/Kconfig \
	devices/timer/Kconfig \
	devices/ramdev/Kconfig \
	devices/mmc/Kconfig \
	devices/serial/Kconfig \
	devices/Kconfig \
	kernel/Kconfig \
	arch/arm64/Kconfig \
	arch/arm32/Kconfig \
	arch/Kconfig \
	Kconfig

include/config/auto.conf: \
	$(deps_config)


$(deps_config): ;
