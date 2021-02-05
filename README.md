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

## Projeto

É necessário configurar o projeto para que possua o `Capabilities`, que se encontra no arquivo `.xcproject` aberto direto pela raiz do projeto no `Xcode` na aba `Signing & Capabilities`. Habilitando o `Push notification` e o `Background modes` os atributos `Background fetch` e `Remote notifications`.

## Handle Notification

No projeto, no arquivo `AppDelegate` é necessário fazer algumas configurações para o funcionamento do SDK, para sincronia com a plataforma Inngage.

É necessário importar o SDK: `#import <Inngage/PushNotificationManager.h>`

Incluindo as seguintes variáveis de classe.
```objc 
@interface AppDelegate (){
    PushNotificationManager *manager;
    NSDictionary *userInfoDict;
}
```

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
  [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:
                                                                        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    
  manager = [PushNotificationManager sharedInstance];
    
  manager.inngageAppToken = @"APP_TOKEN";
  manager.inngageApiEndpoint = @"https://api.inngage.com.br/v1";
  manager.defineLogs = YES;
  manager.enabledShowAlertWithUrl = NO;
  manager.enabledAlert = NO;

  userInfoDict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];

  return YES;
}

```

É necessário inserir o Token disponibilizado no console do Inngage para o direcionamento das chamadas do seu applicativo.
Algumas variáveis estão disponíveis para configuração do SDK.

- `defineLogs` (BOOL): Permite a visualização dos logs no console do Xcode.
- `enabledAlert` (BOOL): Quando enviado um push notification contendo uma URL, caso o usuário abra a notificação, quando o aplicativo estiver em modo ativo, será mostrado um alerta padrão do sistema, com o titulo e o texto da notificação enviada.
- `enabledShowAlerWithUrl` (BOOL): Quando enviado um push notification contendo uma URL, o mesmo não mostra um Alert caso seja definido com o valor `false`. Esse atributo funciona quando o atributo `enabledAlert` possui o valor `true`.

```objc
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings: (UIUserNotificationSettings
                                                                                       *)notificationSettings
{
    [application registerForRemoteNotifications];
    
    [manager handlePushRegisterForRemoteNotifications:notificationSettings];
}
```

Este trecho realizará o registro do usuário na API de push notification, assim como as informações de device do mesmo, para disponibilização de novos push.

```objc
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    NSDictionary *jsonBody = @{ @"Nome":@"XXX" };
    
    [manager handlePushRegistration:deviceToken identifier: @"USER_IDENTIFIER" customField:jsonBody];
    
    if (userInfoDict != nil)
    {
        [manager handlePushReceived:userInfoDict messageAlert:YES];
        
    }
}
```

```objc
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Registration for remote notification failed with error: %@", error.localizedDescription);
    
    [manager handlePushRegistrationFailure:error];
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [manager handlePushReceived:userInfo messageAlert:YES];
}
```

## Notification Service Extension

No projeto, é necessário configurar uma nova extensão no seu arquivo raiz `.xcodeproj` diretamente pelo Xcode.
Assim adicionando a extensão de `Notification Service Extension`.

Uma nova sequência de arquivos será gerada. Caso o projeto seja na linguagem Objective-C, deverá ser adicionado o seguinte código no seguinte método:

```objc
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];

    [NotificationManager prepareNotificationWithRequest:request andBestAttemptContent: self.bestAttemptContent andCompletionHander:^(UNNotificationContent *bestAttemptContent) {
        self.contentHandler(bestAttemptContent);
    }];
}
```

> É necessário importar a seguinte classe: `#import <Inngage/NotificationManager.h>`.

Este trecho de código irá realizar a configuração das notificações remotas quando chegarem para o usuário final.

## Notification Content Extension

No projeto, é necessário configurar uma nova extensão no seu arquivo raiz `.xcodeproj` diretamente pelo Xcode.
Assim adicionando a extensão de `Notification Content Extension`.

Uma nova sequência de arquivos será gerada. Caso o projeto seja na linguagem Objective-C, deverá ser adicionado o seguinte código no seguinte método:

```objc
- (void)didReceiveNotification:(UNNotification *)notification {
    [NotificationManager prepareNotificationContentWithNotification:notification andViewController:self];
}
```

> É necessário importar a seguinte classe: `#import <Inngage/NotificationManager.h>`.

No arquivo de `Info.plist` é necessário informar um novo atributo, na seguinte categoria: `NSExtension`-> `NSExtensionAttributes`, com a seguinte chave `UNNotificationExtensionUserInteractionEnabled` e valor `YES`. Esse atributo permitirá que rich push notification tenham interações pelo usuário.


Estre trecho de código irá realizar a configuração de Rich push notification quando houver interação do usuário por force touch ou long press na bandeja de notificações do sistema. Assim podendo ser apresentado para o usuário imagens (jpg, png, gif) e videos (mp4).