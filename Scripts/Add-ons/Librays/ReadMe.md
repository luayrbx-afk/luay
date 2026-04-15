# 🪟 WindowsV34 Ultimate Lib

qualidades; responsiva, pequena, simples, rápida

### by joaopk(__open source__)
- English version of the reademe [ReadMe.md](https://exemple.com)
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

# ✨ Características

### 🎨 Visual Pastel Customizável
Controle de cores (janela, textos, elementos, scroll, etc)

### 📱 100% Mobile Friendly
responsabilidade em todos os componentes e funções

### 🎬 Animações Suaves
Transições usando TweenService

### 📜 Auto Scroll Inteligente
Scroll adapta automaticamente ao conteúdo

### ⚡ Alta Performance
Código leve e responsivo

### 🧠 Sistema de IDs poderoso
Controle total dos elementos via código



---

# 📦 Instalação
```lua
local LibURL = "https://raw.githubusercontent.com/luayrbx-afk/luay/refs/heads/main/Scripts/Add-ons/Librays/.lib"
local Lib = loadstring(game:HttpGet(LibURL))()
```

---

### 🎨 Temas da Janela

Você pode customizar tudo. Se não definir, usa padrão pastel laranja.

- Campos disponíveis

<img src="https://raw.githubusercontent.com/luayrbx-afk/luay/refs/heads/main/Scripts/Add-ons/Librays/assets/lv_0_20260414204324.png" width="200">


### Exemplo
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

# 🧩 Componentes

### 🏷 Label
```lua
Lib:Label("id_label", "Texto automático com quebra de linha.")
```

---

### 🔘 Button
```lua
Lib:Button("btn_id", "Executar", function()
    print("clicou")
end)
```

---

### 🔁 Toggle
```lua
Lib:Toggle("farm_id", "Auto Farm", false, function(state)
    print(state)
end)
```

---

### 🎚 Slider
```lua
Lib:Slider("ws_id", "Velocidade", 16, 100, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
```

---

### ⌨ Textbox
```lua
Lib:Textbox("name_id", "Nome", "Ex: Rex", function(text, focusLost)
    if focusLost then
        print(text)
    end
end)
```

---

### 🔢 Triple Textbox
```lua
Lib:TripleTextbox("coord_id", "X/Y/Z", "X", "Y", "Z", function(x, y, z)
    print(x, y, z)
end)
```

---

### 📂 Dropdowns

__Seleção única__
```lua
Lib:Dropdown("d1", "Mapa", false, {
    {Name = "Spawn"},
    {Name = "Arena"}
}, function(sel) end)
```
__Com imagem__
```lua
Lib:Dropdown("d2", "Arma", false, {
    {Name = "Katana", Image = "rbxassetid://ID"}
}, function(sel) end)
```
__Multi seleção__
```lua
Lib:Dropdown("d3", "Buffs", true, {
    {Name = "Vida"},
    {Name = "Dano"}
}, function(list) end)
```


---

# 🛠 Sistema de IDs

- Cada elemento fica em:
```lua
Lib.Elements[id]

Setar valor

Lib.Elements["farm_id"].Set(true)

Pegar valor

local value = Lib.Elements["farm_id"].Get()
```


---

# 🖱 Minimizar

# 🧲 Drag responsivo

- Movimento suave


# ➖ Minimizar

- Animação com Tween(suave)


--

# ExempleUseLib
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
