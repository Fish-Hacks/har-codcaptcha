# Generate SD Images
# This script is used to generate datasets for the captcha
import os
import torch
from diffusers import StableDiffusionPipeline
import random
import uuid


PROMPTS = {
    "Bus": [
        "Double-decker bus navigating a narrow street",
        "People waiting in line for a city bus",
        "Bus driver helping a lost passenger with directions",
        "School bus stopping to pick up kids on a sunny morning",
        "Public bus with a striking sunset in the background",
        "Bus covered in snow during winter transportation",
        "Colorful parade float resembling a whimsical bus",
        "Buses lined up at a busy transportation hub",
        "Old-fashioned red London bus in a modern cityscape",
        "Bus passengers engaging in a spontaneous sing-along"
    ],
    "Car": [
        "Car driving through a tunnel with bright lights",
        "Car parked in front of a modern office building",
        "Car driving through a tunnel with bright lights",
        "Car parked in front of a modern office building",
        "Car driving through a tunnel with bright lights",
        "Car parked in front of a modern office building",
        "Car driving through a tunnel with bright lights",
        "Car parked in front of a modern office building",
        "Car driving through a tunnel with bright lights",
        "Car parked in front of a modern office building"
    ],
    "Mountain": [
        "Majestic mountain range covered in snow",
        "Hikers trekking up a steep mountain trail",
        "Mountain climber reaching the summit triumphantly",
        "Sunrise over a tranquil mountain lake",
        "Cabin nestled in the foothills of a grand mountain",
        "Mountain biking through rugged terrain",
        "Mountain peak shrouded in mystic clouds",
        "Wildlife grazing on a picturesque mountain slope",
        "Aerial view of winding roads through mountain passes",
        "Mountain village with colorful houses against a clear sky"
    ],
    "Anime": [
        "Anime character wielding a magical sword",
        "Cute chibi-style anime character with oversized eyes",
        "Heroic anime character in an intense battle pose",
        "Mysterious and brooding anime character in a dark alley",
        "Anime character attending a vibrant school festival",
        "Magical girl transforming into her superhero form",
        "Anime character enjoying a bowl of ramen at a noodle shop",
        "Anime character with a pet companion in a fantasy world",
        "Idol anime character performing on a glittering stage",
        "Anime character caught in a comical mishap"
    ],
    "Rabbits": [
        "Cute bunny nibbling on fresh green grass",
        "Rabbits in a cozy burrow snuggling together",
        "Playful bunny hopping around in a garden",
        "Adorable rabbit grooming its fluffy fur",
        "Baby bunnies exploring a basket full of hay",
        "Curious rabbit investigating a colorful toy",
        "Rabbits enjoying a sunny day in an outdoor enclosure",
        "Sweet bunny stretching out for a lazy nap",
        "Funny bunny binkying in excitement",
        "Rabbits sharing a quiet moment of bunny bonding"
    ],
}

pipe = StableDiffusionPipeline.from_pretrained("runwayml/stable-diffusion-v1-5", torch_dtype=torch.float16)
pipe.to("cuda")

def generate_images(prompt, image_size=512, seed=random.randint(0, 99999)):
    
    image = pipe(
        prompt=prompt,
        width=image_size,
        height=image_size,
        seed=seed,
    ).images[0]

    return image

def get_classes():
    return list(PROMPTS.keys())



def automate(iterations = 999, images_per_class = 100):
    for i in range(iterations):
        for class_name in get_classes():
                for j in range(images_per_class):
                    image = generate_images(class_name)

                    # Create directory if it doesn't exist
                    if not os.path.exists(f"dataset/{class_name}"):
                        os.makedirs(f"dataset/{class_name}")

                    image.save(f"dataset/{class_name}/{uuid.uuid4()}.png")
                    print(f"ITERATION {i} | CLASS {class_name} | IMAGE {j}")

## MAIN
print(get_classes())
automate()