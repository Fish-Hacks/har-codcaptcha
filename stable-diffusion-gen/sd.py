# Generate SD Images
# This script is used to generate datasets for the captcha
import os
import torch
from diffusers import StableDiffusionPipeline
import random
import uuid


PROMPTS = {
    "Bus": [
        # "(Not Required) Insert Specific Prompt Here",
    ],
    "Car": [],
    "Mountain": [],
    "Anime": [],
    "Rabbits": [],
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