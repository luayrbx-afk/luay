# 🪟 WindowsV34 Ultimate Lib

qualities: responsive, small, simple, fast

### by joaopk (open source)

* English version of the README [ReadMe.md](https://exemple.com)

---

### 🚀 Summary

**✨ Features**

**📦 Installation**

**🎨 Window Themes**

**🧩 Components**

* **Label**
* **Button**
* **Toggle**
* **Slider**
* **Textbox**
* **Triple Textbox**
* **Dropdowns**

**🛠 ID System (script control)**

**🖱 Drag & Minimize**

**Example:**
[ExempleUseWindowsv34](https://exemple.com)

---

# ✨ Features

### 🎨 Custom Pastel UI

Full color control (window, texts, elements, scroll, etc)

### 📱 100% Mobile Friendly

Responsive across all components and functions

### 🎬 Smooth Animations

Transitions using TweenService

### 📜 Smart Auto Scroll

Scroll automatically adapts to content

### ⚡ High Performance

Lightweight and responsive code

### 🧠 Powerful ID System

Full control of elements via script

---

# 📦 Installation

```lua
local LibURL = "https://raw.githubusercontent.com/luayrbx-afk/luay/refs/heads/main/Scripts/Add-ons/Librays/.lib"
local Lib = loadstring(game:HttpGet(LibURL))()
```

---

### 🎨 Window Themes

You can customize everything. If not defined, it uses a default pastel orange theme.

* Available fields

<img src="https://raw.githubusercontent.com/luayrbx-afk/luay/refs/heads/main/Scripts/Add-ons/Librays/assets/lv_0_20260414204907.png" width="400">

### Example

```lua
local Win = Lib:Window({
    Name = "My Pro Script",
    MainBg = Color3.fromRGB(120, 150, 220),
    SubBg = Color3.fromRGB(255, 255, 255),
    ScrollBarr = Color3.fromRGB(120, 150, 220),
    BgElements = Color3.fromRGB(120, 150, 220),
    TextsElements = Color3.fromRGB(255, 255, 255)
})
```

---

# 🧩 Components

### 🏷 Label

```lua
Lib:Label("id_label", "Auto text with line break.")
```

---

### 🔘 Button

```lua
Lib:Button("btn_id", "Execute", function()
    print("clicked")
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
Lib:Slider("ws_id", "Speed", 16, 100, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
```

---

### ⌨ Textbox

```lua
Lib:Textbox("name_id", "Name", "Ex: Rex", function(text, focusLost)
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

**Single selection**

```lua
Lib:Dropdown("d1", "Map", false, {
    {Name = "Spawn"},
    {Name = "Arena"}
}, function(sel) end)
```

**With image**

```lua
Lib:Dropdown("d2", "Weapon", false, {
    {Name = "Katana", Image = "rbxassetid://ID"}
}, function(sel) end)
```

**Multi selection**

```lua
Lib:Dropdown("d3", "Buffs", true, {
    {Name = "Health"},
    {Name = "Damage"}
}, function(list) end)
```

---

# 🛠 ID System

* Each element is stored at:

```lua
Lib.Elements[id]
```

Set value:

```lua
Lib.Elements["farm_id"].Set(true)
```

Get value:

```lua
local value = Lib.Elements["farm_id"].Get()
```

---

# 🖱 Minimize

# 🧲 Responsive Drag

* Smooth movement

# ➖ Minimize

* Tween animation (smooth)

---

# ExampleUseLib

```lua
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/luayrbx-afk/luay/refs/heads/main/Scripts/Add-ons/Librays/.lib"))()

local Main = Lib:Window({
    Name = "WindowsV34 Showcase",
    MainBg = Color3.fromRGB(251, 181, 84),
    SubBg = Color3.fromRGB(255, 255, 255)
})

Lib:Label("lb", "Full demonstration.")

Lib:Toggle("t1", "Fly", false, function(v)
    print(v)
end)

Lib:Button("b1", "Toggle Fly (ID)", function()
    Lib.Elements["t1"].Set(not Lib.Elements["t1"].Get())
end)

Lib:Slider("s1", "Jump", 50, 200, 50, function(v)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
end)

Lib:Textbox("txt1", "Tag", "Type...", function(t)
    print(t)
end)

Lib:TripleTextbox("rgb", "RGB", "R", "G", "B", function(r,g,b)
    print(r,g,b)
end)

Lib:Dropdown("dr1", "Maps", false, {
    {Name = "Forest"},
    {Name = "Village", Image = "rbxassetid://6031075931"}
}, function(sel)
    print(sel)
end)

Lib:Dropdown("dr2", "Equipment", true, {
    {Name = "Vest"},
    {Name = "Helmet"}
}, function(list)
    print(#list)
end)

Lib:Label("end", "End.")
```

