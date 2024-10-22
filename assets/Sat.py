import json

const = [1, 2, 3, 5, 7, 11, 13, 17, 19, 23, 29,
        31, 37, 41, 43, 47, 53, 59, 61, 67, 71,
        73, 79, 83, 89, 97, 101, 103, 107, 109,
        113, 127, 131, 137, 139, 149, 151, 157,
        163, 167, 173, 179, 181, 191, 193, 197, 199
    ]

with open('dictionary.json', 'r') as file:
    data = json.load(file)

for i, e in enumerate(data):
    if isinstance(e['id'], int):
        data[i]['id'] = str(e['id'])
    else:
        continue


with open('dictionary.json', 'w') as file:
    json.dump(data, file, indent=4)


