if VERSION >= v"1.3" && !haskey(ENV, "JULIA_CLP_LIBRARY_PATH")
    exit()  # Use Clp_jll instead.
end

using BinaryProvider

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    LibraryProduct(prefix, ["libClp"], :libClp),
    LibraryProduct(prefix, ["libOsiClp"], :libOsiClp),
    LibraryProduct(prefix, ["libClpSolver"], :libClpSolver),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/JuliaBinaryWrappers/Clp_jll.jl/releases/download/Clp-v1.17.6+4"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.aarch64-linux-gnu-libgfortran3-cxx03.tar.gz", "059439acc52693be3f02fa5af4a64178d29b8682df25371884bc19be19b9e786"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.aarch64-linux-gnu-libgfortran3-cxx11.tar.gz", "39d1b7528b328ddb3ab59ba28da8e0eccc9c9ae5af8ea07c45cf137b16705cef"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.aarch64-linux-gnu-libgfortran4-cxx03.tar.gz", "a98d527a2d0a29e8f2ea4158ab3ed1ffc825286427328cad1a7711ec441cc92d"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.aarch64-linux-gnu-libgfortran4-cxx11.tar.gz", "f435877ef8863296760285027a79e8d061836d21389d36f3713a1fa512793757"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.aarch64-linux-gnu-libgfortran5-cxx03.tar.gz", "ae7515a6849cff6818e5c0819ae8320535c5fcc797aca75ede4dd0486c7117dc"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.aarch64-linux-gnu-libgfortran5-cxx11.tar.gz", "3b46bacb16a3f561fbf47ce7079951b8a1cb003b750de72199568a168a5dfbf5"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.aarch64-linux-musl-libgfortran3-cxx03.tar.gz", "04f7518752e7195d7d725e19ee47e9d0184ae9273880424e60ff385bc6b94599"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.aarch64-linux-musl-libgfortran3-cxx11.tar.gz", "1583ea3f2567c3d88b5680b98901f75e0ce61af957c0c78c033fbc641649af88"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.aarch64-linux-musl-libgfortran4-cxx03.tar.gz", "62895d58c94272cc5060d0837ab78fc31f16e87629d5f7e95569c810af2d780a"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.aarch64-linux-musl-libgfortran4-cxx11.tar.gz", "39b4de5459d304e1db21817d3d90c85edb20630d5c6aa7c05b2a0b1fb4c4540d"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.aarch64-linux-musl-libgfortran5-cxx03.tar.gz", "cc4232538b8faf5a045ea397ed2e28951b6c1b7e74e030c0c9d79c20763ed560"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.aarch64-linux-musl-libgfortran5-cxx11.tar.gz", "b11bed9fb7f537b88040d68c4ce49fb5c83195e56ad6d466def251f992a292f3"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.armv7l-linux-gnueabihf-libgfortran3-cxx03.tar.gz", "30969dc5bac04677737167372e205586b154fe38e458ccba051f2ba4333e05b8"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.armv7l-linux-gnueabihf-libgfortran3-cxx11.tar.gz", "e28cc87c9c6b4c1b5a1161654505ad05c9048bf6e50699a477f56aa202cb1bab"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.armv7l-linux-gnueabihf-libgfortran4-cxx03.tar.gz", "d33c1e4c12af9ccec3e636f3b29d7538a7eae71e0d71cedffbec51e552165f20"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.armv7l-linux-gnueabihf-libgfortran4-cxx11.tar.gz", "7370687426d753d516e9855151e42b5a03c741e1bab7086ca63b033ee7abc16d"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.armv7l-linux-gnueabihf-libgfortran5-cxx03.tar.gz", "fa76a2342cae9d0b795d89b11f0475f7cce8726c26b3d95e86567ae711e803ee"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.armv7l-linux-gnueabihf-libgfortran5-cxx11.tar.gz", "e491590dbfb93578df18727d75b232c6d3fd183129e227ecb9d5b95b1487277c"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.armv7l-linux-musleabihf-libgfortran3-cxx03.tar.gz", "3676265097ab9c2e7f4acc66d72d0adc6c5035fb5c5c74245553e0f971934465"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.armv7l-linux-musleabihf-libgfortran3-cxx11.tar.gz", "673a83dd7c4416552fa735cc74253d63d47b0bf553818a3ad4af606ba5ee827d"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.armv7l-linux-musleabihf-libgfortran4-cxx03.tar.gz", "08acd28c93cef77b92c8624e716b98f4fb1fde49a5a9a1948eb63e11426079c9"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.armv7l-linux-musleabihf-libgfortran4-cxx11.tar.gz", "51fd91bb457b4383892f8b54cf70c1a337d542ae93853f51c2ec6debcd42bb43"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.armv7l-linux-musleabihf-libgfortran5-cxx03.tar.gz", "71c72009b18c5585dbcb4c77b54e1f64e10cd87d07924bd4e4d46d20ce3f1f94"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.armv7l-linux-musleabihf-libgfortran5-cxx11.tar.gz", "e88098e676b92a4feaee97cfb25ddc949c7c97f137420d52055089345363c4ba"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.i686-linux-gnu-libgfortran3-cxx03.tar.gz", "4bf40f8a12b821d6edc86a7dc55431c1ee73ec56d2875ef41c7b974bf6b85c6d"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.i686-linux-gnu-libgfortran3-cxx11.tar.gz", "809012f81214a22e5e6a6fd00b7f4eb3699a6965c7e87abe9fc0df47cf367e7d"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.i686-linux-gnu-libgfortran4-cxx03.tar.gz", "b0d35e6b29ed5c15bf62b6f2bd07c5911eb998f434919611253b8a8eac5dd4c2"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.i686-linux-gnu-libgfortran4-cxx11.tar.gz", "ec8324c8b230ed7befd57346f2285932906d927e874b403b7d87c1bd32fef9ea"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.i686-linux-gnu-libgfortran5-cxx03.tar.gz", "73f6bde94a838d595a70f5fb1d06485afe0adfcd248c119c98dbb64129af8fdb"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.i686-linux-gnu-libgfortran5-cxx11.tar.gz", "5dad9d1fab13faa83ebdd7bb7d690952a09ddb46cee428185a7abe8566ea3fad"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.i686-linux-musl-libgfortran3-cxx03.tar.gz", "ef21bfebbbeca91f0c3feac91b47ea087a5e229c0867217137ad3248e804004a"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.i686-linux-musl-libgfortran3-cxx11.tar.gz", "24e55b07918952a4320c08b2a2fff96625984438ebadcb6a6515a845fff1c5bb"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.i686-linux-musl-libgfortran4-cxx03.tar.gz", "6c1625eb19d2dd5f9e63c702a611520a11220d5e5448cf2e9c4d1af39596dc0e"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.i686-linux-musl-libgfortran4-cxx11.tar.gz", "29141af307f06d55c4646cad74d64644edc7185768a3d33cae647464bc04cf2f"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.i686-linux-musl-libgfortran5-cxx03.tar.gz", "f4c33d89f50a7287675165122e9c69289e2599cf78bcbe3cb041817ab2c50884"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.i686-linux-musl-libgfortran5-cxx11.tar.gz", "271d40ca1f82e79a69f18526acb4eec12c18a12a1f6cde0b573f254e73c67f73"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.i686-w64-mingw32-libgfortran3-cxx03.tar.gz", "9a18a4440afc4bfe501a5a14ae13a3d6a99d5c0c3974aec887edd172d1e6382d"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.i686-w64-mingw32-libgfortran3-cxx11.tar.gz", "0129cfdb0018918a4aed88d5e4b7512fafc2ba7e837fb01ac7c1882611927ecc"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.i686-w64-mingw32-libgfortran4-cxx03.tar.gz", "42a0314dc96d0f22c9d18c549a698c56b3b5caabf1c88390a12b2552c38c63b3"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.i686-w64-mingw32-libgfortran4-cxx11.tar.gz", "450d21545f3b860ed05f636d122d9751992d94466c352ea4f86a86454db58cbc"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.i686-w64-mingw32-libgfortran5-cxx03.tar.gz", "e5151713849c9b274442dfd5585cfe38ead5706f764516f373c4b69aaf992a9a"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.i686-w64-mingw32-libgfortran5-cxx11.tar.gz", "ce6663cfb8cf471f119c7b01ca311656f09c710c5850795dc5b72d67422944c6"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.x86_64-apple-darwin14-libgfortran3-cxx03.tar.gz", "96a580aa70f931196779d45722ab5aca18ee07b7c4944952550b600d253b0b4d"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.x86_64-apple-darwin14-libgfortran3-cxx11.tar.gz", "9a5c31a93e87b804e2712a90ec15a4913fb126235445fa09b8d6047b74c3f364"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.x86_64-apple-darwin14-libgfortran4-cxx03.tar.gz", "f9ca0649a69b0b4921db84a83dbc56bcd161842bac81eb6f31ce15e919073347"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.x86_64-apple-darwin14-libgfortran4-cxx11.tar.gz", "53bcfb7ba0c9a5a5f45cbc033d09d10bf542559f2501167ad224a6aaf9b8c5c0"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.x86_64-apple-darwin14-libgfortran5-cxx03.tar.gz", "4e5761e0edcddef0f32690451b0ee047e3f53095f7d12a5951fae29549b1926d"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.x86_64-apple-darwin14-libgfortran5-cxx11.tar.gz", "5f16402c0f0451aa02aae7b131b6043819f29059d5be13c7021c4716b9e64fb5"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.x86_64-linux-gnu-libgfortran3-cxx03.tar.gz", "9985690f528d2b22e31184a725e643b808fb5d3a275d320b726a3baf70105eac"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.x86_64-linux-gnu-libgfortran3-cxx11.tar.gz", "991531cce8c7f62289f36aab551cc3318fa51867e3d5250a5b727c2a943be3cb"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.x86_64-linux-gnu-libgfortran4-cxx03.tar.gz", "1b158ee674aa6c2545eeed2dc301dc9a44efd1a3bc3a14d6be8886ff8ad1429f"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.x86_64-linux-gnu-libgfortran4-cxx11.tar.gz", "b47ff51552a4701f8cbbf29c8fea92a32a1ea279e9bb55973061741619d1c20e"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.x86_64-linux-gnu-libgfortran5-cxx03.tar.gz", "85e40e2e121f8d0c71a4cdc625b29348ff32457845c06ca8ccad9e3cf34569cf"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.x86_64-linux-gnu-libgfortran5-cxx11.tar.gz", "b3c7abe76b820bac309f89c437e422117e37cc75b2c6d518b796e03892238318"),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.x86_64-linux-musl-libgfortran3-cxx03.tar.gz", "73acc89560dc5664444bd8f38f6173ae32f320d4893c6092503648a013075f0a"),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.x86_64-linux-musl-libgfortran3-cxx11.tar.gz", "92c66b1014a4fa0f42e1e11568f9ac0ea592b8406f8df163ffbed17fd2ecf8f8"),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.x86_64-linux-musl-libgfortran4-cxx03.tar.gz", "14334725b48f7c13cdde4f7c3a3adfa38b15b561e1ad9e6f1667729582b26af2"),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.x86_64-linux-musl-libgfortran4-cxx11.tar.gz", "33fa27d4f91cda9b6913ff3d3eb591186c45249433b280f5bc523e0a98664be5"),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.x86_64-linux-musl-libgfortran5-cxx03.tar.gz", "a437d3e04cb8cc5f672290e51b670d6f20f39086acbe87f48c3d236bff39c96b"),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.x86_64-linux-musl-libgfortran5-cxx11.tar.gz", "68edc01cd657d9ff979ed2329f2a6459dd69c4bc363f0305ecebf0539f3ba016"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.x86_64-w64-mingw32-libgfortran3-cxx03.tar.gz", "f8f5e919145542e67ec5a38bc84f7eacff91f4a427079540eb87d74b6109884f"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.x86_64-w64-mingw32-libgfortran3-cxx11.tar.gz", "ad8a66ecb1e1a19f33dc35346dbb9b9833b03c10a2002a5b9234a886e8e33348"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.x86_64-w64-mingw32-libgfortran4-cxx03.tar.gz", "44b8d6c8d08f98274364f7008af4375b1a3c56a212792c49cfa6b44b17abfb95"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.x86_64-w64-mingw32-libgfortran4-cxx11.tar.gz", "9385fbf05223267b36a3b5607aaac5bb87c378a79a7bdf769909f9603049c752"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Clp.v1.17.6.x86_64-w64-mingw32-libgfortran5-cxx03.tar.gz", "c5f936529b68613c72b6df816f305c98dbf4370dfcf82dc0c1ae3df2a0a40b12"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Clp.v1.17.6.x86_64-w64-mingw32-libgfortran5-cxx11.tar.gz", "d41cbab7481daf57a475dc445192085737e4768ff702402ba70c009e1bf1cd7a"),
)

# To fix gcc4 bug in Windows
# https://sourceforge.net/p/mingw-w64/bugs/727/
this_platform = platform_key_abi()
if typeof(this_platform) == Windows && this_platform.compiler_abi.gcc_version == :gcc4
   this_platform = Windows(
       arch(this_platform);
       libc = libc(this_platform),
       compiler_abi = CompilerABI(:gcc6)
    )
end

custom_library = false
if haskey(ENV, "JULIA_CLP_LIBRARY_PATH")
    custom_products = [
        LibraryProduct(
            ENV["JULIA_CLP_LIBRARY_PATH"],
            product.libnames,
            product.variable_name
        ) for product in products
    ]
    if all(satisfied(p; verbose = verbose) for p in custom_products)
        products = custom_products
        custom_library = true
    else
        error("Could not install custom libraries from $(ENV["JULIA_CLP_LIBRARY_PATH"]).\nTo fall back to BinaryProvider call delete!(ENV,\"JULIA_CLP_LIBRARY_PATH\") and run build again.")
    end
end

if !custom_library
    # Install unsatisfied or updated dependencies:
    # We added `, isolate=true` as otherwise, it would segfault when closing `OpenBLAS32`,
    # probably because it is conflicting with Julia openblas.
    unsatisfied = any(!satisfied(p; verbose=verbose, isolate=true) for p in products)

    dl_info = choose_download(download_info, this_platform)
    if dl_info === nothing && unsatisfied
        # If we don't have a compatible .tar.gz to download, complain.
        # Alternatively, you could attempt to install from a separate provider,
        # build from source or something even more ambitious here.
        error("Your platform (\"$(Sys.MACHINE)\", parsed as \"$(triplet(platform_key_abi()))\") is not supported by this package!")
    end

    # If we have a download, and we are unsatisfied (or the version we're
    # trying to install is not itself installed) then load it up!
    if unsatisfied || !isinstalled(dl_info...; prefix=prefix)
        # Download and install binaries
        evalfile("build_CompilerSupportLibraries.v0.3.3.jl")
        evalfile("build_OpenBLAS32.v0.3.9.jl")
        evalfile("build_CoinUtils.v2.11.3.jl")
        evalfile("build_Osi.v0.108.5.jl")
        install(dl_info...; prefix=prefix, force=true, verbose=true)
    end
 end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=true)
