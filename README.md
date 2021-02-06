# Inngage iOS

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Inngage.svg)](https://img.shields.io/cocoapods/v/Inngage.svg)
[![Platform](https://img.shields.io/cocoapods/p/Inngage.svg?style=flat)](https://alamofire.github.io/Inngage)

# Instalação

Para instalação da biblioteca, utilize o CocoaPods.
No arquivo de `Podfile` adicione a seguinte linha para o projeto principal:

```ruby
  pod 'Inngage/Core'
```

Para os _targets_ projetos de extensão, como `Notification Service Extension` e `Notification Content Extension`, que trabalha com os códigos específicos de notificação remota, insira a seguinte linha:

```ruby
pod 'Inngage/NotificationExtension'
```

O projeto é separado em 2 modulos, o `Core` que possui seu escopo para gerenciamento de _push notifications_ quando o aplicativo é aberto, e o `NotificationExtension` que gerencia os _push notifications_ de bandeja, assim como _rich push notification_.

Ainda no arquivo de Podfile, insira o seguinte `post script`, para desabilitar validações cujo não sejam designadas para API na compilação dos _frameworks_ de extensão:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'NO'
    end
  end
end
```

Depois só executar o comando `pod install` no terminal, na pasta do projeto. A partir deste momento será utilizado o arquivo com a extensão `.xcworkspace`.

> No projeto `Example` pode se verificar como o arquivo de `Podfile` foi escrito e atribuido os códigos descritos.

# Configuração

> Para configuração utilizando o projeto em Objective-C, consulte o arquivo `README_ObjectiveC.md`.

## Projeto

É necessário configurar o projeto para que possua o `Capabilities`, que se encontra no arquivo `.xcproject` aberto direto pela raiz do projeto no `Xcode` na aba `Signing & Capabilities`. Habilitando o `Push notification` e o `Background modes` os atributos `Background fetch` e `Remote notifications`.

## Handle Notification

No projeto, no arquivo `AppDelegate` é necessário fazer algumas configurações para o funcionamento do SDK, para sincronia com a plataforma Inngage.

É necessário importar o SDK: `import Inngage`

Incluindo as seguintes variáveis de classe.
```swift 
var pushNotificationManager = PushNotificationManager.sharedInstance()
var userInfoDictionary: [String: Any]?
```

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    pushNotificationManager?.inngageAppToken = "APP_TOKEN"
    pushNotificationManager?.inngageApiEndpoint = "https://api.inngage.com.br/v1"
    pushNotificationManager?.defineLogs = true
    pushNotificationManager?.enabledShowAlertWithUrl = false
    pushNotificationManager?.enabledAlert = false

    if let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any] {
        self.userInfoDictionary = userInfo
    }

    return true
}
```

É necessário inserir o Token disponibilizado no console do Inngage para o direcionamento das chamadas do seu applicativo.
Algumas variáveis estão disponíveis para configuração do SDK.

- `defineLogs` (Bool): Permite a visualização dos logs no console do Xcode.
- `enabledAlert` (Bool): Quando enviado um push notification, caso o usuário abra a notificação, quando o aplicativo estiver em modo ativo, será mostrado um alerta padrão do sistema, com o titulo e o texto da notificação enviada.
- `enabledShowAlerWithUrl` (Bool): Quando enviado um push notification contendo uma URL, o mesmo não mostra um Alert caso seja definido com o valor `false`. Esse atributo funciona quando o atributo `enabledAlert` possui o valor `true`.

Este trecho realizará o registro do usuário na API de push notification, assim como as informações de device do mesmo, para disponibilização de novos push.

```swift
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    let userInfo = ["name": "XXX"]

    pushNotificationManager?.handlePushRegistration(deviceToken, identifier: "USER_IDENTIFIER", customField: userInfo)

    if let userInfoDictionary = userInfoDictionary {
        pushNotificationManager?.handlePushReceived(userInfoDictionary, messageAlert: true)
    }
}
```

Este trecho registrará os casos de falha do registro de push notification.

```swift
func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    pushNotificationManager?.handlePushRegistrationFailure(error)
}
```

Este trecho de código enviará o log para o servidor da Inngage sobre o recebimento do push.

```swift
func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    pushNotificationManager?.handlePushReceived(userInfo, messageAlert: true)
}
```

## Notification Service Extension

No projeto, é necessário configurar uma nova extensão no seu arquivo raiz `.xcodeproj` diretamente pelo Xcode.
Assim adicionando a extensão de `Notification Service Extension`.

Uma nova sequência de arquivos será gerada. Caso o projeto seja na linguagem Swift, deverá ser adicionado o seguinte código no seguinte método:

```swift
override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
    self.contentHandler = contentHandler
    bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
    
    NotificationManager.prepareNotification(with: request, andBestAttempt: bestAttemptContent) { [weak self] (bestAttemptContent) in
        if let bestAttemptContent = bestAttemptContent {
            self?.contentHandler?(bestAttemptContent)
        }
    }
}
```

> É necessário importar a seguinte classe: `import Inngage`.

Este trecho de código irá realizar a configuração das notificações remotas quando chegarem para o usuário final.

## Notification Content Extension

No projeto, é necessário configurar uma nova extensão no seu arquivo raiz `.xcodeproj` diretamente pelo Xcode.
Assim adicionando a extensão de `Notification Content Extension`.

Uma nova sequência de arquivos será gerada. Caso o projeto seja na linguagem Swift, deverá ser adicionado o seguinte código no seguinte método:

```swift
func didReceive(_ notification: UNNotification) {
    NotificationManager.prepareNotificationContent(with: notification, andViewController: self)
}
```

> É necessário importar a seguinte classe: `import Inngage`.

No arquivo de `Info.plist` é necessário informar um novo atributo, na seguinte categoria: `NSExtension`-> `NSExtensionAttributes`, com a seguinte chave `UNNotificationExtensionUserInteractionEnabled` e valor `YES`. Esse atributo permitirá que rich push notification tenham interações pelo usuário.

Estre trecho de código irá realizar a configuração de Rich push notification quando houver interação do usuário por force touch ou long press na bandeja de notificações do sistema. Assim podendo ser apresentado para o usuário imagens (jpg, png, gif) e videos (mp4).