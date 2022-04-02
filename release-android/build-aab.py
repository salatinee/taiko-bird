import argparse
import subprocess
import urllib
from pathlib import Path
import shutil
import re
import io
import os
from PIL import Image
import json


# A pasta que esse script está
this_directory = Path(__file__).parent

# A pasta contendo o repositório do love-android
love_android_directory = this_directory / "love-android"

# Pasta com os arquivos do jogo
game_directory = Path(__file__).parent.parent


def clean_directory(directory: Path):
    try:
        shutil.rmtree(directory)
    except:
        pass

    try:
        os.makedirs(directory)
    except:
        pass


def download_uber_apk_signer():
    output_file = this_directory / "uber-apk-signer-1.2.1.jar"
    url = "https://github.com/patrickfav/uber-apk-signer/releases/download/v1.2.1/uber-apk-signer-1.2.1.jar"

    if not output_file.exists():
        with urllib.request.urlopen(url) as response, open(
            output_file, "wb"
        ) as out_file:
            shutil.copyfileobj(response, out_file)
            out_file.flush()
            out_file.close()


def clone_love_android_repository():
    if love_android_directory.exists():
        # Não precisa clonar
        return

    subprocess.check_call(
        [
            "git",
            "clone",
            "--recurse-submodules",
            "--depth",
            "1",
            "https://github.com/aureki/love-android-extensions.git",
            "love-android",
        ],
        cwd=this_directory,
    )


def copy_game_files():
    # Pasta de destino
    target_directory = (
        Path(__file__).parent / "love-android" / "app" / "src" / "embed" / "assets"
    )

    # Limpar a pasta destino e recriar
    clean_directory(target_directory)

    ignored_files_and_folders = [
        ".git",
        ".gitignore",
    ]

    # Copia os arquivos do jogo, exceto esta pasta, para o diretório de destino
    for file_or_directory in game_directory.glob("*"):
        if file_or_directory.name in ignored_files_and_folders:
            continue

        if file_or_directory != this_directory:
            if file_or_directory.is_dir():
                shutil.copytree(
                    file_or_directory, target_directory / file_or_directory.name
                )
            else:
                shutil.copy(file_or_directory, target_directory)


def patch_android_manifest():
    replacements = {
        r'android:label="LÖVE for Android"': r'android:label="taiko bird"',
        r'android:screenOrientation="landscape"': r'android:screenOrientation="portrait"',
    }

    manifest_file = (
        Path(__file__).parent
        / "love-android"
        / "app"
        / "src"
        / "main"
        / "AndroidManifest.xml"
    )
    with io.open(manifest_file, "r+", encoding="utf-8") as f:
        content = f.read()

        for old, new in replacements.items():
            content = content.replace(old, new)

        f.seek(0)
        f.write(content)
        f.truncate()


def patch_build_gradle():
    replacements = {
        r"applicationId '.*'": r"applicationId 'org.salatinee.taikobird'",
        r"versionCode \d+": r"versionCode 1",
        r"versionName '.*'": r"versionName '1.0'",
    }

    build_gradle_file = Path(__file__).parent / "love-android" / "app" / "build.gradle"
    with open(build_gradle_file, "r+") as f:
        content = f.read()

        for old, new in replacements.items():
            content = re.sub(old, new, content)

        f.seek(0)
        f.write(content)
        f.truncate()

def patch_gradle_properties():
    replacements = {
        r"applicationId '.*'": r"applicationId 'org.salatinee.taikobird'",
        r"versionCode \d+": r"versionCode 1",
        r"versionName '.*'": r"versionName '1.0'",
    }

    build_gradle_file = Path(__file__).parent / "love-android" / "app" / "build.gradle"
    with open(build_gradle_file, "r+") as f:
        content = f.read()

        for old, new in replacements.items():
            content = re.sub(old, new, content)

        f.seek(0)
        f.write(content)
        f.truncate()


def copy_gradle_properties():
    with open(this_directory / "gradle.properties", "r") as f:
        our_gradle_properties = f.read()

        gradle_properties_file = love_android_directory / "gradle.properties"
        with open(gradle_properties_file, "w") as f2:
            f2.write(our_gradle_properties)

def create_app_icons():
    icons_and_sizes = {
        "mdpi": 48,
        "hdpi": 72,
        "xhdpi": 96,
        "xxhdpi": 144,
        "xxxhdpi": 192,
    }

    # A pasta que esse script está
    this_directory = Path(__file__).parent

    with Image.open(this_directory / "icon.png") as image:
        for icon, size in icons_and_sizes.items():
            target = (
                this_directory
                / "love-android"
                / "app"
                / "src"
                / "main"
                / "res"
                / ("drawable-" + icon)
                / "love.png"
            )
            resized_image = image.resize((size, size), Image.ANTIALIAS)

            resized_image.save(target)


gradlew_directory = Path(__file__).parent / "love-android"
gradlew_executable = gradlew_directory / "gradlew"


def clean_outputs():
    # A pasta que esse script está
    this_directory = Path(__file__).parent

    outputs_folder = this_directory / "love-android" / "app" / "build" / "outputs"

    clean_directory(outputs_folder)

def mark_gradlew_as_executable():
    subprocess.check_call([
        'chmod', '+x', str(gradlew_executable)
    ])

def generate_apk():
    subprocess.check_call(
        [gradlew_executable, "assembleEmbedNoRecordRelease"], cwd=gradlew_directory
    )


def generate_aab():
    subprocess.check_call(
        [gradlew_executable, "bundleEmbedNoRecordRelease"], cwd=gradlew_directory
    )


def sign_apk_and_save_to_folder():
    apk_signer_path = this_directory / "uber-apk-signer-1.2.1.jar"
    apk_path = (
        love_android_directory
        / "app"
        / "build"
        / "outputs"
        / "apk"
        / "embedNoRecord"
        / "release"
        / "app-embed-noRecord-release-unsigned.apk"
    )
    output_apk = this_directory / "taiko-bird.apk"

    subprocess.check_call(
        [
            "java",
            "-jar",
            str(apk_signer_path),
            "--apks",
            str(apk_path),
            "-o",
            str(output_apk),
        ]
    )


def sign_aab_and_save_to_folder():
    unsigned_aab_path = (
        love_android_directory
        / "app"
        / "build"
        / "outputs"
        / "apk"
        / "embedNoRecordRelease"
        / "app-embed-noRecord-release.aab"
    )
    output_aab_path = this_directory / "taiko-bird.aab"

    subprocess.check_call(
        [
            "jarsigner",
            "-verbose",
            "-sigalg",
            "SHA1withRSA",
            "-keystore",
            "taiko-bird-key.jks",
            "-signedjar",
            str(output_aab_path),
            str(unsigned_aab_path),
            "taiko-bird-key",
        ]
    )


def meow(language: str = "jp"):
    if language == "jp" or not language:
        print("にゃー")
    elif language == "zh":  # ?
        print(".")
    else:
        print("meow")


def create_argument_parser():
    parser = argparse.ArgumentParser()
    parser.add_argument("--generate-signed-aab", action="store_true", default=False)
    return parser


def main(args):
    meow("zh")  # af miau chines
    download_uber_apk_signer()
    clone_love_android_repository()
    copy_game_files()
    patch_android_manifest()
    patch_build_gradle()
    copy_gradle_properties()
    create_app_icons()
    clean_outputs()
    mark_gradlew_as_executable()
    generate_apk()
    generate_aab()
    sign_apk_and_save_to_folder()

    if args.generate_signed_aab:
        sign_aab_and_save_to_folder()


if __name__ == "__main__":
    parser = create_argument_parser()
    args = parser.parse_args()

    main(args)
