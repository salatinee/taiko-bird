import subprocess
from zipfile import ZipFile
import os
from pathlib import Path
import shutil

def create_game_love():
    with ZipFile('taikobird.love', 'w') as zip:
        # Pasta com os arquivos do jogo
        game_directory = Path(__file__).parent.parent

        ignored_files_and_folders = [
            game_directory / '.git',
            game_directory / '.gitignore',
            game_directory / 'release-windows',
            game_directory / 'release-android',
        ]

        for folder, subfolders, files in os.walk(Path(__file__).parent.parent):
            for file in files:
                filepath = os.path.join(folder, file)
                unsafe = False
                for ignored_file_and_folder in ignored_files_and_folders:
                    # Verifica se o arquivo atual é igual ao ignorado
                    if Path(filepath) == ignored_file_and_folder:
                        unsafe = True
                    
                    # Verifica se o arquivo atual está dentro de uma das pastas ignoradas
                    if ignored_file_and_folder in Path(filepath).absolute().parents:
                        unsafe = True
                        
                if not unsafe:
                    new_filepath = filepath.replace(str(Path(__file__).parent.parent), '')
                    zip.write(filepath, new_filepath)
                else:
                    continue

def create_love_exe():
    pass

def create_game_exe():
    subprocess.check_call(['cmd', '/c', 'copy /b love_files\\love.exe+taikobird.love love_files\\taikobird.exe'])

def main():
    create_game_love()
    create_love_exe()
    create_game_exe()

if __name__ == "__main__":
    main()
