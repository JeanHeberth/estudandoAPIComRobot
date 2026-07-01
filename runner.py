import os
import subprocess

TESTES = {
    "1": ("health", "tests/api/health"),
    "2": ("login", "tests/api/login"),
    "3": ("usuario", "tests/api/usuario"),
    "4": ("produto", "tests/api/produto"),
    "5": ("pedido", "tests/api/pedido"),
    "6": ("todos", "tests/api"),
}


def executar(nome, caminho):
    resultado = f"results/{nome}"

    os.makedirs(resultado, exist_ok=True)

    comando = [
        "robot",
        "-d",
        resultado,
        caminho
    ]

    print(f"\nExecutando: {' '.join(comando)}\n")

    subprocess.run(comando)


def menu():
    while True:
        print("\n==============================")
        print("      ROBOT API RUNNER")
        print("==============================")
        print("1 - Health")
        print("2 - Login")
        print("3 - Usuário")
        print("4 - Produto")
        print("5 - Pedido")
        print("6 - Executar todos")
        print("0 - Sair")
        print("==============================")

        opcao = input("Escolha uma opção: ")

        if opcao == "0":
            print("Saindo...")
            break

        if opcao in TESTES:
            nome, caminho = TESTES[opcao]
            executar(nome, caminho)
        else:
            print("Opção inválida.")


if __name__ == "__main__":
    menu()