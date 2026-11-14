# 📱 SmartPet Mobile — Aplicativo do Tutor

Aplicativo mobile do Pet Shop SmartPet, desenvolvido em **Flutter**, para tutores acompanharem atendimentos, agendarem serviços e avaliarem o pet shop.

Este app é o **cliente**. Ele não tem banco de dados próprio — tudo vem da API do backend Java
([smartpet-web](https://github.com/jucathegoat/smartpet-web)).

---

## 📋 Índice

1. [Como funciona](#-como-funciona)
2. [Pré-requisitos](#-pré-requisitos)
3. [Primeira execução](#-primeira-execução)
4. [Configuração do endereço da API](#-configuração-do-endereço-da-api)
5. [Rodar no emulador](#-rodar-no-emulador)
6. [Rodar no celular físico](#-rodar-no-celular-físico)
7. [Gerar o APK](#-gerar-o-apk)
8. [Login e cadastro](#-login-e-cadastro)
9. [Solução de problemas](#-solução-de-problemas)
10. [Estrutura do projeto](#-estrutura-do-projeto)

---

## 🏗 Como funciona

```
┌──────────────────┐         HTTP/JSON        ┌──────────────────┐
│  App Flutter     │  ──────────────────────▶ │  Backend Java   │
│  (celular)       │                          │  Tomcat :8080    │
└──────────────────┘                          └────────┬─────────┘
                                                       ▼
                                              ┌──────────────────┐
                                              │  MySQL (Aiven)   │
                                              └──────────────────┘
```

**O app não acessa o banco.** Ele só conversa com a API. Por isso o backend
precisa estar rodando em algum lugar que o celular consiga alcançar.

Todas as chamadas HTTP passam por **um único cliente** (`lib/servicos/api_cliente.dart`),
que centraliza:

- timeout de 15 segundos
- decodificação UTF-8 correta (`bodyBytes` — evita acentos quebrados)
- mensagens de erro em português (`ApiException`)
- tratamento de `401`, `403`, `404`, `500`

---

## ✅ Pré-requisitos

| Item | Versão |
|---|---|
| **Flutter SDK** | 3.22 ou superior |
| **Dart** | vem com o Flutter |
| **Android Studio** | para o emulador e o SDK |
| **Backend rodando** | smartpet-web no ar (local ou Render) |

Confira se está tudo instalado:

```powershell
flutter doctor
```

---

## 🚀 Primeira execução

```powershell
cd C:\caminho\smartpet-mobile
flutter pub get
```

---

## ⚙️ Configuração do endereço da API

O endereço fica em `lib/config/api_config.dart`. Ele escolhe **automaticamente**
conforme o ambiente:

| Ambiente | Endereço usado |
|---|---|
| Emulador Android | `http://10.0.2.2:8080/smartpet` |
| Desktop / Web | `http://localhost:8080/smartpet` |
| **Celular físico** | precisa ser definido manualmente |

> **Por que `10.0.2.2`?** No emulador, esse é o endereço do computador que o hospeda.
> `localhost` no emulador seria o próprio emulador, que não tem servidor.

### Sobrescrever o endereço

Para apontar para outro lugar (celular físico, Render, IP da rede), use `--dart-define`:

```powershell
flutter run --dart-define=SMARTPET_API_URL=http://192.168.0.10:8080/smartpet
```

O valor **não fica gravado no código** — entra na hora de compilar. Isso mantém o
repositório limpo e permite um APK diferente para cada situação.

---

## 🤖 Rodar no emulador

```powershell
flutter run
```

Nada mais a configurar — o `ApiConfig` já usa `10.0.2.2` sozinho.

---

## 📱 Rodar no celular físico

### 1. Descubra o IP do computador

```powershell
ipconfig | Select-String "IPv4"
```

Vai aparecer algo como `192.168.0.10`.

### 2. Confirme que o celular está na mesma rede

Celular e computador precisam estar **no mesmo Wi-Fi**.

### 3. Rode apontando para o IP

```powershell
flutter run --dart-define=SMARTPET_API_URL=http://192.168.0.10:8080/smartpet
```

### 4. Libere a porta no firewall (Windows)

Na primeira vez o Windows pergunta. Se não perguntar:

```powershell
New-NetFirewallRule -DisplayName "SmartPet 8080" -Direction Inbound `
  -LocalPort 8080 -Protocol TCP -Action Allow -Profile Private
```

> **`localhost` não funciona no celular.** `localhost` no celular é o próprio celular.
> Ele não tem servidor nem banco rodando.

---

## 📦 Gerar o APK

```powershell
flutter build apk --release --dart-define=SMARTPET_API_URL=http://192.168.0.10:8080/smartpet
```

O arquivo sai em:

```
build/app/outputs/flutter-apk/app-release.apk
```

### Se o endereço mudar, precisa recompilar

O endereço fica **dentro do APK**. Se o IP do computador mudar (outro Wi-Fi, outra
rede), é preciso gerar um novo APK com o novo endereço.

A alternativa definitiva é hospedar o backend e apontar para uma URL fixa:

```powershell
flutter build apk --release --dart-define=SMARTPET_API_URL=https://smartpet-xxxx.onrender.com/smartpet
```

Aí o mesmo APK funciona em qualquer lugar — 4G, outro Wi-Fi, outra cidade.

### ⚠️ Limpeza antes de recompilar

Se o build falhar com *"Failed to delete some children"*, algum processo está
segurando a pasta `build/`:

```powershell
flutter clean
flutter build apk --release --dart-define=SMARTPET_API_URL=http://SEU_IP:8080/smartpet
```

---

## 🔑 Login e cadastro

O app autentica contra a tabela `tutor` do banco, pela rota:

```
POST /smartpet/login/usuario
{ "usuario": "...", "senha": "..." }
```

### Criar uma conta

1. Na tela de login, toque em **Cadastre-se**
2. Preencha nome, CPF, e-mail, usuário e senha
3. Depois faça login com o usuário e senha cadastrados

### Mensagens de erro

| Situação | O que aparece |
|---|---|
| Usuário ou senha errados | `Usuário ou senha incorretos` |
| Conta inativa | `Conta inativa. Procure o pet shop.` |
| Backend fora do ar | mostra o endereço que tentou acessar |
| Timeout | `O servidor demorou para responder` |

> O login do **painel administrativo** (`adm`) não funciona aqui. São autenticações diferentes.

---

## 🔧 Solução de problemas

### `ClientException with SocketException: Connection refused`

O app não alcançou o servidor. Verifique, nesta ordem:

1. **O backend está rodando?** Abra no navegador do computador:
   `http://localhost:8080/smartpet/health/db` → deve devolver `{"ok":true}`
2. **O endereço está certo?** Confira o que o app mostra na tela de erro.
3. **O celular está na mesma rede?** Teste abrir o IP no navegador do celular.
4. **Firewall?** Veja o comando da seção [celular físico](#-rodar-no-celular-físico).

### Alguém respondeu, mas com erro

Use a régua para saber quem respondeu na porta 8080:

| Resposta | Quem é |
|---|---|
| `{"ok":true}` | Tomcat (Java) ✓ correto |
| `404 Route not found` | `backend.dart` (Dart) — **pare esse processo** |
| `Falha ao consultar o MySQL` | Tomcat no ar, banco errado |

> `bin/backend.dart` é código legado. Ele disputa a porta 8080 com o Tomcat
> e **não deve ser executado**.

### Acentos quebrados nos textos

O `ApiCliente` já decodifica como UTF-8. Se ainda aparecer errado, o problema está
no backend, não no app.

### `flutter: command not found`

O Flutter SDK não está no PATH. Adicione `C:\src\flutter\bin` às variáveis de ambiente,
ou use o caminho completo:

```powershell
C:\src\flutter\bin\flutter.bat run
```

---

## 📁 Estrutura do projeto

```
smartpet-mobile/
├── lib/
│   ├── main.dart
│   ├── config/
│   │   └── api_config.dart          # decide o endereço da API
│   ├── servicos/
│   │   └── api_cliente.dart         # cliente HTTP único (timeout, UTF-8, erros)
│   ├── modelos/                     # classes de dados
│   └── telas/
│       ├── tela_login.dart          # login + loading + mensagens de erro
│       ├── tela_cadastro.dart       # cadastro de tutor
│       ├── tela_principal.dart
│       ├── tela_pets.dart
│       ├── tela_novo_agendamento.dart   # envia JSON para a API
│       ├── tela_meus_atendimentos.dart
│       └── ...
├── android/
│   └── app/src/main/res/xml/
│       └── network_security_config.xml  # libera HTTP para 10.0.2.2 e localhost
├── bin/
│   └── backend.dart                 # ⚠️ LEGADO — não executar
└── pubspec.yaml
```

### Dependências

| Pacote | Uso |
|---|---|
| `http` | chamadas HTTP para a API |
| `flutter_secure_storage` | guardar o token de sessão |

> `bin/backend.dart` usa `shelf`, `mysql1`, `oracledb` e `dart_jsonwebtoken`.
> Essas dependências existem no `pubspec.yaml` apenas para esse código legado.
> O app **não** as utiliza.

---

## 📄 Projeto relacionado

| Repositório | O que é |
|---|---|
| [smartpet-web](https://github.com/jucathegoat/smartpet-web) | backend Java (Servlet + Tomcat) + painel administrativo |

---

## ⚠️ Segurança

Este é um projeto acadêmico. Antes de usar de verdade:

- o backend guarda **senhas em texto puro** na tabela `tutor`
- algumas rotas usam o **CPF como única credencial**
- a API libera `Access-Control-Allow-Origin: *`

Detalhes no README do [smartpet-web](https://github.com/jucathegoat/smartpet-web#-segurança--leia-antes-de-publicar).

---

## 📄 Licença

Projeto acadêmico — SmartPet Pet Shop.
