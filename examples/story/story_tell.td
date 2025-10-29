import "canvas"
import "image"
import "times"
import "os"
import "path"
import "fs"
import "strings"
import "math"
import "helper/randint"
import "console"

// console.hide()

var w = 800
var h = 600

// Visual Novel Data
var current_scene = 0
var current_background = "backgrounds/park_evening.png"
var current_character = ""
var current_dialogue = ""
var character_expression = "normal"

// Character sprites (we'll use the existing 32 sprites for different characters/expressions)
var characters = {
    "narrator": ["sprite/1.png"],
    "tokio": ["sprite/2.png", "sprite/3.png", "sprite/4.png"], // normal, surprised, smug
    "anya": ["sprite/5.png", "sprite/6.png"], // normal, crying
    "shina": ["sprite/7.png", "sprite/8.png", "sprite/9.png", "sprite/10.png"], // masked, unmasked, dramatic, embarrassed
    "blade": ["sprite/11.png"],
    "eyepatch": ["sprite/12.png"], 
    "memeko": ["sprite/13.png"]
}

// Backgrounds (you'll need to create these)
var backgrounds = [
    "backgrounds/park_evening.png",
    "backgrounds/dark_room.png",
    "backgrounds/phantom_base.png"
]

// Chapter 1 Scenes
var scenes = [
    // Scene 0: Opening narration
    {
        background: "backgrounds/park_evening.png",
        character: "narrator",
        expression: "normal",
        dialogue: "Chapter 1: Join Us\nJune 26, 2016 - Evening. The streetlights began to flicker on.\nTokio Yukawa, a top student at North State Academy, was returning home late."
    },
    
    // Scene 1: Tokio's monologue
    {
        background: "backgrounds/park_evening.png", 
        character: "tokio",
        expression: "normal",
        dialogue: "\"Today has to be my unluckiest day of the month. I should've finished those assignments during summer vacation. If I had, I could've avoided today's punishment... ugh...\""
    },
    
    {
        background: "backgrounds/park_evening.png",
        character: "tokio", 
        expression: "normal",
        dialogue: "\"After enduring hours of sensei's 'special lesson'... ugh... and now I have to finish all the assignments by tomorrow too... Looks like it's time to get my mojo back.\""
    },
    
    // Scene 2: Park scene
    {
        background: "backgrounds/park_evening.png",
        character: "narrator",
        expression: "normal", 
        dialogue: "He bought a soda and sat on a bench in the park for a while. Suddenly, he noticed an elementary school girl appear out of nowhere, crying."
    },
    
    {
        background: "backgrounds/park_evening.png",
        character: "tokio",
        expression: "surprised",
        dialogue: "\"Now what, a lost child? Should I talk to her?\""
    },
    
    // Scene 3: Meeting Anya
    {
        background: "backgrounds/park_evening.png",
        character: "tokio",
        expression: "normal",
        dialogue: "\"Hey, missy, what's your name?\""
    },
    
    {
        background: "backgrounds/park_evening.png",
        character: "anya",
        expression: "crying", 
        dialogue: "\"A-Anya.\""
    },
    
    {
        background: "backgrounds/park_evening.png",
        character: "tokio",
        expression: "normal",
        dialogue: "\"I guess you're lost, right? Want me to take you to the police station?\""
    },
    
    {
        background: "backgrounds/park_evening.png", 
        character: "narrator",
        expression: "normal",
        dialogue: "While walking with her, he bought her an ice cream. As they walked, a thought crossed his mind:"
    },
    
    {
        background: "backgrounds/park_evening.png",
        character: "tokio",
        expression: "surprised", 
        dialogue: "\"What is a little kid doing out at this hour?\""
    },
    
    {
        background: "backgrounds/park_evening.png",
        character: "narrator",
        expression: "normal",
        dialogue: "Before he could ask, the girl spoke up."
    },
    
    {
        background: "backgrounds/park_evening.png",
        character: "anya",
        expression: "normal",
        dialogue: "\"This way... my home...\""
    },
    
    // Scene 4: Kidnapping
    {
        background: "backgrounds/park_evening.png",
        character: "narrator",
        expression: "normal", 
        dialogue: "A sudden realization struck Tokio."
    },
    
    {
        background: "backgrounds/park_evening.png",
        character: "tokio",
        expression: "surprised",
        dialogue: "\"Wait, you remember the way to your home?\""
    },
    
    {
        background: "backgrounds/park_evening.png",
        character: "narrator", 
        expression: "normal",
        dialogue: "But before he could react, a thick fog surrounded him."
    },
    
    {
        background: "backgrounds/park_evening.png",
        character: "tokio",
        expression: "surprised",
        dialogue: "\"Wait, what's this smell? Chloroform?!\""
    },
    
    {
        background: "backgrounds/park_evening.png",
        character: "narrator",
        expression: "normal",
        dialogue: "His eyes shifted to Anya—she was already wearing some kind of gas mask."
    },
    
    {
        background: "backgrounds/park_evening.png",
        character: "tokio", 
        expression: "surprised",
        dialogue: "\"Wait, what—?\""
    },
    
    {
        background: "backgrounds/park_evening.png",
        character: "narrator",
        expression: "normal", 
        dialogue: "Before he could finish his thought, he collapsed."
    },
    
    // Scene 5: Waking up
    {
        background: "backgrounds/dark_room.png",
        character: "narrator",
        expression: "normal",
        dialogue: "A dark room.\nTokio slowly began to regain consciousness. His eyes fluttered open, but his vision was blurry."
    },
    
    {
        background: "backgrounds/dark_room.png", 
        character: "narrator",
        expression: "normal",
        dialogue: "Through the haze, he saw a girl in a black outfit, something like an assassin's uniform, and a white mask that looked like one of those \"hacker\" masks."
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "narrator",
        expression: "normal",
        dialogue: "Around her, others in matching outfits were helping her hurry along, just as Tokio's vision cleared completely."
    },
    
    // Scene 6: Shina's dramatic introduction
    {
        background: "backgrounds/dark_room.png",
        character: "shina",
        expression: "dramatic",
        dialogue: "\"WAHAHAHAHA! So, you have dared to reclaim your consciousness, pitiful mortal!\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina", 
        expression: "dramatic",
        dialogue: "\"Now! Prepare yourself! Bear witness to the ultimate CHAOS! Those who peddle in evil shall be CRUSHED by the almighty, swirling darkness of the BLACK HOLE!\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina",
        expression: "dramatic", 
        dialogue: "\"We are the unseen storm, the fangs in the shadows, the justice that memes itself into reality!\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "narrator",
        expression: "normal",
        dialogue: "She snapped her fingers.\nSpotlights clicked on, bathing her in a glorious, overly dramatic glow."
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "narrator",
        expression: "normal", 
        dialogue: "Her teammates shuffled into formation behind her, striking poses they had definitely practiced in front of a mirror."
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina",
        expression: "dramatic",
        dialogue: "\"We are... THE PHANTOMS!\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "narrator",
        expression: "normal",
        dialogue: "Cue a giant, badly made cardboard sign falling from the ceiling that read \"THE PHANTOMS\" in huge glittery letters."
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "tokio",
        expression: "surprised", 
        dialogue: "Am I dreaming... or did I just get kidnapped by a bunch of cosplay addicts?!"
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "tokio",
        expression: "smug",
        dialogue: "\"Did you borrow those lines from some TV show or something? This looks so cringe.\""
    },
    
    // Scene 7: Mask falls off
    {
        background: "backgrounds/dark_room.png",
        character: "shina",
        expression: "embarrassed", 
        dialogue: "\"Cringe...?\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina",
        expression: "embarrassed",
        dialogue: "\"Wait a second—who gave you permission to talk?!\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "tokio", 
        expression: "smug",
        dialogue: "\"Huh, so I am being kidnapped by some weird-ass cosplayers.\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina",
        expression: "embarrassed",
        dialogue: "\"What did you just say?!\""
    },
    
    {
        background: "backgrounds/dark_room.png", 
        character: "narrator",
        expression: "normal",
        dialogue: "In the middle of her tantrum, her mask slipped off—\nand underneath, a cute face with long white hair was revealed."
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "tokio",
        expression: "surprised",
        dialogue: "Well... she actually looks kinda cute."
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "narrator", 
        expression: "normal",
        dialogue: "The girl froze, realizing her mask had fallen.\nHer cheeks turned bright pink for a moment, but she quickly coughed into her fist and tried to recover her \"cool\" villain act."
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina",
        expression: "embarrassed",
        dialogue: "\"Ahem! Y-You dare gaze upon my divine garden without permission?! Mortal, prepare yourself for—uh—eternal doom or something!\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "narrator",
        expression: "normal", 
        dialogue: "She awkwardly picked up her mask and tried to jam it back on, but it was upside down.\nOne of her teammates whispered, \"Boss, the mask's backwards...\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "narrator",
        expression: "normal",
        dialogue: "She hissed at them to shut up under her breath, spun around quickly, and adjusted her mask properly."
    },
    
    // Scene 8: Serious conversation
    {
        background: "backgrounds/dark_room.png",
        character: "tokio", 
        expression: "normal",
        dialogue: "\"So, would you please drop the act and tell me why I'm tied up in this chair?\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina",
        expression: "normal",
        dialogue: "\"Isn't it obvious already—?\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "tokio",
        expression: "normal", 
        dialogue: "\"—Kidnapped, right?\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "tokio",
        expression: "normal",
        dialogue: "\"So why don't you just ask for my parents' number and ransom me or something... Or maybe you already did?\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina", 
        expression: "normal",
        dialogue: "\"HELL no!\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina",
        expression: "normal",
        dialogue: "\"We're not interested in your boring parents!\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina",
        expression: "normal", 
        dialogue: "\"Rather... we want something much more important—\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina",
        expression: "normal",
        dialogue: "\"You.\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "tokio", 
        expression: "surprised",
        dialogue: "\"...What do you mean by me?\""
    },
    
    // Scene 9: Proper introduction
    {
        background: "backgrounds/dark_room.png",
        character: "shina",
        expression: "normal",
        dialogue: "\"I guess... my dramatic introduction was a failure,\"\n\"So let's do this properly. Seriously, this time.\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina",
        expression: "normal", 
        dialogue: "\"I'm Shina Yatoizawa,\"\n\"Leader of this—uh, cult.\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina",
        expression: "embarrassed",
        dialogue: "\"I mean! Not a cult! Team! Team! The Phantoms!\""
    },
    
    {
        background: "backgrounds/dark_room.png", 
        character: "tokio",
        expression: "smug",
        dialogue: "Here we go again, he thought."
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina",
        expression: "normal",
        dialogue: "\"Anyway. Listen carefully. There's a hidden evil organization called Aybus,\"\n\"They're responsible for a series of terrorist attacks...\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina", 
        expression: "normal",
        dialogue: "\"You've probably seen some of it on the news—bombings, hijacking incidents, strange disappearances.\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina",
        expression: "normal",
        dialogue: "\"And we, The Phantoms, fight against them. From the shadows.\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "tokio", 
        expression: "smug",
        dialogue: "\"That's great and all, but can you explain how me being tied to a chair is connected to any of this?\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "tokio",
        expression: "smug",
        dialogue: "\"Are you seriously accusing me of being one of the terrorists you mentioned?\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina", 
        expression: "normal",
        dialogue: "\"No, no! That's not it!\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina",
        expression: "dramatic",
        dialogue: "\"Perhaps... you were summoned here... to join us!\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "tokio", 
        expression: "surprised",
        dialogue: "\"Huh? What?\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina",
        expression: "dramatic",
        dialogue: "\"You see, we, The Phantoms, have been lacking one crucial member... a mad scientist... someone to create divine weapons to fight against Aybus!\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "narrator", 
        expression: "normal",
        dialogue: "Tokio just stared at her like she had grown a second head."
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina",
        expression: "normal",
        dialogue: "\"And you, Tokio Yukawa, though just an average high schooler, have a true passion for science itself,\"\n\"You can fill the role we've been missing!\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "narrator", 
        expression: "normal",
        dialogue: "Tokio raised an eyebrow, his face twisted in disbelief."
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina",
        expression: "normal",
        dialogue: "\"So, what's your answer? Wanna join the Phantoms?\""
    },
    
    // Scene 10: Decision
    {
        background: "backgrounds/dark_room.png",
        character: "tokio", 
        expression: "normal",
        dialogue: "So they're definitely not kidnappers... what a relief.\nI'm not sure if her story's real, but whatever. I'll just play along for now..."
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "tokio",
        expression: "normal",
        dialogue: "As soon as I get home, I've gotta finish those damn assignments..."
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "tokio", 
        expression: "normal",
        dialogue: "\"Sure, whatever. Just untie me already.\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina",
        expression: "surprised",
        dialogue: "\"Wait—really? Weren't you about to refuse?!\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "tokio", 
        expression: "normal",
        dialogue: "\"Umm, actually... no one's ever complimented my passion for science like that before, so... you kinda got me there.\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "narrator",
        expression: "normal",
        dialogue: "The other masked members looked at each other dramatically, totally confused."
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "narrator", 
        expression: "normal",
        dialogue: "Tokio held out his hand, and Shina quickly shook it, sealing the deal like a real dealers."
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "blade",
        expression: "normal",
        dialogue: "\"So... he's recruited, Boss?\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina", 
        expression: "normal",
        dialogue: "\"Yes.\""
    },
    
    // Scene 11: Team introductions
    {
        background: "backgrounds/dark_room.png",
        character: "narrator",
        expression: "normal",
        dialogue: "One by one, the masked members pulled off their masks - three of them, not counting Shina."
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "blade", 
        expression: "normal",
        dialogue: "\"Man, that was a pain in the ass,\"\n\"Hi! I'm Blade.\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "eyepatch",
        expression: "normal",
        dialogue: "\"Yo, I'm called Eyepatch.\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "memeko", 
        expression: "normal",
        dialogue: "\"And I'm Memeko the hacker.\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "narrator",
        expression: "normal",
        dialogue: "Finally free, Tokio stood up, clicked his glasses into place, and struck the most ridiculously over-the-top pose imaginable."
    },
    
    // Scene 12: Tokio's dramatic reveal
    {
        background: "backgrounds/dark_room.png",
        character: "tokio",
        expression: "dramatic", 
        dialogue: "\"And I am... the limit of ENTROPY... disarranged by INFINITY... crushed by the BLACK HOLE... and reborn from the WHITE HOLE...\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "tokio",
        expression: "dramatic",
        dialogue: "\"the self-proclaimed prodigy... Tokkio Yukkkhawa...\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "tokio", 
        expression: "dramatic",
        dialogue: "\"A.K.A... the Maddox!\""
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "narrator",
        expression: "normal",
        dialogue: "Everyone stared at him, dead silent."
    },
    
    {
        background: "backgrounds/dark_room.png",
        character: "shina", 
        expression: "normal",
        dialogue: "\"...You're even weirder than I am.\""
    },
    
    // Scene 13: Chapter End
    {
        background: "backgrounds/dark_room.png",
        character: "narrator",
        expression: "normal",
        dialogue: "Chapter 1 Complete\n\nCharacters Met:\n• Anya\n• Shina Yatoizawa  \n• Blade\n• Eyepatch\n• Memeko Dennou\n• Tokio Yukawa"
    }
]

var font_data = embed("fonts/IBMPlexSans-Bold.ttf")

fn get_character_sprite(character, expression) {
    if character == "narrator" {
        return "sprite/1.png" // Default narrator sprite
    }
    
    var char_data = characters[character]
    if char_data == null {
        return "sprite/1.png"
    }
    
    // Map expressions to sprite indices
    var expression_map = {
        "normal": 0,
        "surprised": 1, 
        "smug": 2,
        "crying": 1,
        "dramatic": 2,
        "embarrassed": 3
    }
    
    var index = expression_map[expression] || 0
    if index >= char_data.length {
        index = 0
    }
    
    return char_data[index]
}

fn draw(ctx) {
    // Draw background
    if fs.exists(current_background) {
        var bg_img = image.load(current_background)
        var bg_data = fs.readfile(current_background)
        ctx.drawimage(bg_data, 0, 0, w, h)
    } else {
        // Fallback background
        ctx.hex("#2c3e50")
        ctx.clear()
    }
    
    // Draw character sprite
    var sprite_file = get_character_sprite(current_character, character_expression)
    if fs.exists(sprite_file) && current_character != "narrator" {
        var img = image.load(sprite_file)
        var b = img.bounds()
        var scale_factor = 300.0 / math.max(b.size.width, b.size.height)
        var scaled_width = b.size.width * scale_factor
        var scaled_height = b.size.height * scale_factor
        
        // Position character on right side
        ctx.drawimage(img, w - scaled_width - 50, h/2 - scaled_height/2)
    }
    
    // Draw dialogue box
    ctx.hex("#2c3e50e0") // Semi-transparent dark blue
    ctx.rect(50, h - 200, w - 100, 150)
    ctx.fill()
    
    ctx.hex("#ecf0f1") // Light border
    ctx.rect(50, h - 200, w - 100, 150)
    ctx.stroke()
    
    // Draw character name plate
    if current_character != "narrator" {
        ctx.hex("#e74c3c") // Red name plate
        ctx.rect(50, h - 230, 200, 30)
        ctx.fill()
        
        ctx.hex("#ffffff")
        ctx.fontface(font_data, 18)
        ctx.text(strings.to_upper(current_character), 60, h - 210)
        ctx.fill()
    }
    
    // Draw dialogue text
    ctx.hex("#ecf0f1") // Light text color
    ctx.fontface(font_data, 16)
    
    // Wrap text
    var words = strings.split(current_dialogue, " ")
    var line = ""
    var lines = []
    var max_width = w - 150
    
    for word in words {
        var test_line = line + word + " "
        var metrics = ctx.measure_text(test_line)
        if metrics[0] > max_width && line != "" {
            lines.push(line)
            line = word + " "
        } else {
            line = test_line
        }
    }
    lines.push(line)
    
    // Display wrapped text
    var start_y = h - 180
    for i, text_line in lines {
        if i < 6 { // Max 6 lines
            ctx.text(text_line, 70, start_y + (i * 22))
            ctx.fill()
        }
    }
    
    // Draw continue indicator
    ctx.hex("#f39c12")
    ctx.fontface(font_data, 14)
    // var bounce = math.sin(times.now() * 8) * 3
    ctx.text("Click to continue...", w - 150, h - 40)
    ctx.fill()
    
    // Draw scene progress
    ctx.hex("#34495e")
    ctx.rect(50, h - 250, w - 100, 5)
    ctx.fill()
    
    ctx.hex("#e74c3c")
    var progress_width = (w - 100) * (current_scene + 1) / scenes.length
    ctx.rect(50, h - 250, progress_width, 5)
    ctx.fill()
    
    // Draw scene number
    ctx.hex("#bdc3c7")
    ctx.fontface(font_data, 12)
    ctx.text(format("Scene %d/%d", current_scene + 1, scenes.length), w - 100, h - 260)
    ctx.fill()
    
    // Draw chapter title
    ctx.hex("#ffffff")
    ctx.fontface(font_data, 20)
    ctx.text("Chapter 1: Join Us", 60, 40)
    ctx.fill()
}

fn advance_scene() {
    if current_scene < scenes.length - 1 {
        current_scene += 1
        var scene = scenes[current_scene]
        current_background = scene.background
        current_character = scene.character
        current_dialogue = scene.dialogue
        character_expression = scene.expression
    } else {
        // Loop back to beginning when finished
        current_scene = 0
        var scene = scenes[current_scene]
        current_background = scene.background
        current_character = scene.character  
        current_dialogue = scene.dialogue
        character_expression = scene.expression
    }
}

fn load_scene(index) {
    current_scene = index
    var scene = scenes[current_scene]
    current_background = scene.background
    current_character = scene.character
    current_dialogue = scene.dialogue
    character_expression = scene.expression
}

var options = {
    width: w,
    height: h,
    title: "Visual Novel - Chapter 1: Join Us",
    fullscreen: false,
    borderless: false,
    top_most: false,
    no_scaling: false,
    x: 200,
    y: 100
}

// Initialize first scene
load_scene(0)

canvas.new_window(options, fn(window){
    ctx := window.new_context(w, h)
    
    draw(ctx)
    window.update(w, h)
    
    for {
        e := window.next_event()
        if e.type == "size" {
            w = e.width_px 
            h = e.height_px
            ctx = window.new_context(e.width_px, e.height_px)
            draw(ctx)
            window.update(w, h)
        }
        else if e.type == "lifecycle" && e.from == 3 && e.to == 0 {
            break
        }
        else if e.type == "mouse" && e.direction == 1 {
            // Advance scene on click
            advance_scene()
            draw(ctx)
            window.update(w, h)
        }
        else if e.type == "key" && e.direction == 1 {
            // Spacebar or Enter to advance
            if e.key == " " || e.key == "Enter" {
                advance_scene()
                draw(ctx)
                window.update(w, h)
            }
        }
        else if e.type == "tick" {
            // Redraw for animations
            draw(ctx)
            window.update(w, h)
        }
    }
})