# Lista de Criptomoedas

Aplicativo Flutter que consome a API da Coin Market Cap para listar criptomoedas e suas cotações.

## Funcionalidades

- Listagem de criptomoedas com preços em USD e BRL
- Busca por múltiplas criptomoedas (separadas por vírgula)
- Pull-to-refresh para atualizar os dados
- Detalhes da criptomoeda ao clicar em um item
- Indicador de carregamento durante as requisições
- Lista padrão de criptomoedas quando nenhuma busca é realizada

## Arquitetura

O projeto segue o padrão arquitetural MVVM (Model-View-ViewModel):

- **Model**: Representação dos dados das criptomoedas
- **View**: Interface do usuário
- **ViewModel**: Gerenciamento de estado e lógica de negócios
- **Repository**: Camada de abstração para acesso aos dados
- **DataSource**: Comunicação direta com a API

## Requisitos

- Flutter SDK
- Dart SDK
- Conexão com a internet
- Chave de API da Coin Market Cap

## Instalação

1. Clone o repositório
2. Execute `flutter pub get` para instalar as dependências
3. Execute `flutter run` para iniciar o aplicativo

## Dependências

- provider: ^6.0.5
- http: ^1.1.0
- intl: ^0.18.1
- connectivity_plus: ^5.0.1
- flutter_dotenv: ^5.1.0

## API Key

O projeto utiliza a API da Coin Market Cap com a chave dentro do arquivo `crypto_service.dart`. Para usar sua própria chave:

1. Obtenha uma chave de API em [Coin Market Cap](https://coinmarketcap.com/api/)
2. Abra o arquivo `lib/services/crypto_service.dart`
3. Substitua o valor da variável `_apiKey` pela sua chave