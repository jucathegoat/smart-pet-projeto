# SmartPet — Aplicativo Flutter

Aplicativo mobile do SmartPet para tutores e equipe da recepção. O app acessa o backend Spring Boot para consultar pets, entrar na fila, avaliar serviços e comprar produtos.

## Estrutura

```text
smart-pet-projeto/
├── lib/main.dart                 # inicialização, login e navegação principal
├── lib/config/app_config.dart    # endereço base e timeout da API
├── lib/tela_*.dart               # telas de pets, loja, fila e avaliações
├── lib/telas/                    # telas adicionais da recepção e do tutor
├── lib/servicos/                 # acesso e modelos de serviços
├── assets/                       # imagens e recursos visuais
├── android/, ios/, web/, windows/ # destinos Flutter
└── pubspec.yaml                  # dependências e configuração Flutter
```

## Requisitos

- Flutter instalado e disponível no `PATH`
- Backend SmartPet em execução
- Para celular físico, dispositivo conectado e endereço do backend acessível pela rede

## Executar no Windows

Abra PowerShell nesta pasta:

```powershell
flutter pub get
flutter run -d windows
```

Para conferir os dispositivos disponíveis, use `flutter devices`; então execute `flutter run -d <id-do-dispositivo>`.

## Conexão com o backend

O endereço padrão está em `lib/config/app_config.dart` e aponta para `http://localhost:8080`, adequado quando o backend roda na mesma máquina. Em um celular físico, altere `baseUrl` para o endereço IP da máquina que está executando o backend, mantendo a porta 8080.

## Principais fluxos

- **Pets:** cadastro, listagem, edição e remoção
- **Agendamento e fila:** seleção de pet e serviço, acompanhamento e cancelamento
- **Loja:** consulta de produtos e compra
- **Avaliações:** nota e comentário para atendimentos e compras
- **Recepção:** painel ao vivo da fila
