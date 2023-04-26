EAPI=8

CMAKE_MAKEFILE_GENERATOR="ninja"
inherit cmake

DESCRIPTION="On-screen annotation tool"
HOMEPAGE="https://github.com/bk138/gromit-mpx"
SRC_URI="https://github.com/bk138/gromit-mpx/archive/refs/tags/${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="appindicator"
KEYWORDS="amd64"

BDEPEND="virtual/pkgconfig"
DEPEND="
	>=x11-libs/gtk+-3.22
	>=x11-apps/xinput-1.3
	appindicator? ( dev-libs/libayatana-appindicator )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-forward-declaration.patch
	"${FILESDIR}"/${P}-appindicator-support.patch
)

src_prepare() {
	cmake_src_prepare

	# For some reason 'CMAKE_INSTALL_SYSCONFDIR' prepends '/usr' so the config
	# ends up getting installed as '/usr/etc/gromit-mpx.conf' which is not
	# correct.
	sed -i 's@CMAKE_INSTALL_SYSCONFDIR@CMAKE_INSTALL_FULL_SYSCONFDIR@' \
		CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DWITH_APPINDICATOR=$(usex appindicator ON OFF)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
}

pkg_postinst() {
	xdg_icon_cache_update
}

