# 🪟 WindowsV34 Ultimate Lib

Biblioteca de UI estilo Windows XP Pastel para Roblox

Uma lib de interface leve, rápida e totalmente customizável, feita pra quem quer UI bonita sem matar o FPS.
Foco total em mobile + performance + nostalgia Windows XP pastel.


---

### 🚀 Sumário

__✨ Características__

__📦 Instalação__

__🎨 Temas da Janela__

__🧩 Componentes__

- **Label**

- **Button**

- **Toggle**

- **Slider**

- **Textbox**

- **Triple Textbox**

- **Dropdowns**


__🛠 Sistema de IDs para alteração via Script__

__🖱 Drag & Minimizar__

__Exemplo:__
[ExempleUseWindowsv34](https://exemple.com)


---

✨ Características

🎨 Visual Pastel Customizável
Controle total de cores (janela, textos, elementos, scroll, etc)

📱 100% Mobile Friendly
Sistema de toque inteligente (sem bug de arrastar)

🎬 Animações Suaves
Transições usando TweenService

📜 Auto Scroll Inteligente
Scroll adapta automaticamente ao conteúdo

⚡ Alta Performance
Código leve e responsivo

🧠 Sistema de IDs poderoso
Controle total dos elementos via código



---

📦 Instalação
```lua
local LibURL = "https://raw.githubusercontent.com/luayrbx-afk/luay/refs/heads/main/Scripts/Add-ons/Librays/.lib"
local Lib = loadstring(game:HttpGet(LibURL))()
```

---

🎨 Temas da Janela

Você pode customizar tudo. Se não definir, usa padrão pastel laranja.

Campos disponíveis

Campo	Descrição

Name	Título da janela
MainBg	Barra superior + bordas
SubBg	Fundo interno
Title	Cor do título
ScrollBarr	Barra de scroll
ScrollArrows	Setas do scroll
BgElements	Fundo dos elementos
TextsElements	Texto dos elementos


Exemplo
```lua
local Win = Lib:Window({
    Name = "Meu Script Pro",
    MainBg = Color3.fromRGB(120, 150, 220),
    SubBg = Color3.fromRGB(255, 255, 255),
    ScrollBarr = Color3.fromRGB(120, 150, 220),
    BgElements = Color3.fromRGB(120, 150, 220),
    TextsElements = Color3.fromRGB(255, 255, 255)
})
```

---

🧩 Componentes

🏷 Label
```lua
Lib:Label("id_label", "Texto automático com quebra de linha.")
```

---

🔘 Button
```lua
Lib:Button("btn_id", "Executar", function()
    print("clicou")
end)
```

---

🔁 Toggle
```lua
Lib:Toggle("farm_id", "Auto Farm", false, function(state)
    print(state)
end)
```

---

🎚 Slider
```lua
Lib:Slider("ws_id", "Velocidade", 16, 100, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
```

---

⌨ Textbox
```lua
Lib:Textbox("name_id", "Nome", "Ex: Rex", function(text, focusLost)
    if focusLost then
        print(text)
    end
end)
```

---

🔢 Triple Textbox
```lua
Lib:TripleTextbox("coord_id", "X/Y/Z", "X", "Y", "Z", function(x, y, z)
    print(x, y, z)
end)
```

---

📂 Dropdowns

Seleção única
```lua
Lib:Dropdown("d1", "Mapa", false, {
    {Name = "Spawn"},
    {Name = "Arena"}
}, function(sel) end)
```
Com imagem
```lua
Lib:Dropdown("d2", "Arma", false, {
    {Name = "Katana", Image = "rbxassetid://ID"}
}, function(sel) end)
```
Multi seleção
```lua
Lib:Dropdown("d3", "Buffs", true, {
    {Name = "Vida"},
    {Name = "Dano"}
}, function(list) end)
```


---

🛠 Sistema de IDs

Cada elemento fica em:
```lua
Lib.Elements[id]

Setar valor

Lib.Elements["farm_id"].Set(true)

Pegar valor

local value = Lib.Elements["farm_id"].Get()
```


---

🖱 Drag & Minimizar

🧲 Drag Inteligente

Não buga em mobile

Ignora toques secundários

Movimento suave


➖ Minimizar

Animação com Tween

Esconde conteúdo

Mantém header visível


--

🌟 Exemplo Completo
```lua
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/luayrbx-afk/luay/refs/heads/main/Scripts/Add-ons/Librays/.lib"))()

local Main = Lib:Window({
    Name = "WindowsV34 Showcase",
    MainBg = Color3.fromRGB(251, 181, 84),
    SubBg = Color3.fromRGB(255, 255, 255)
})

Lib:Label("lb", "Demonstração completa.")

Lib:Toggle("t1", "Fly", false, function(v)
    print(v)
end)

Lib:Button("b1", "Toggle Fly (ID)", function()
    Lib.Elements["t1"].Set(not Lib.Elements["t1"].Get())
end)

Lib:Slider("s1", "Pulo", 50, 200, 50, function(v)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
end)

Lib:Textbox("txt1", "Tag", "Digite...", function(t)
    print(t)
end)

Lib:TripleTextbox("rgb", "RGB", "R", "G", "B", function(r,g,b)
    print(r,g,b)
end)

Lib:Dropdown("dr1", "Mapas", false, {
    {Name = "Floresta"},
    {Name = "Vila", Image = "rbxassetid://6031075931"}
}, function(sel)
    print(sel)
end)

Lib:Dropdown("dr2", "Equipamentos", true, {
    {Name = "Colete"},
    {Name = "Capacete"}
}, function(list)
    print(#list)
end)

Lib:Label("end", "Fim.")
```
