from collections import Counter
from json import load

def clean_prompt(prompt):
    return prompt.strip().replace('\n', ' ')

def trace(count, description):
    print(f'{count:5,d}', description)

def main():
    with open('prompts.json', mode='r', encoding='utf8') as file:
        data = load(file)

    prompts = [clean_prompt(prompt) for prompt in data['prompts']]
    vars_count = sum(1 if p == 'Variation from: ORIGINAL' else 0 for p in prompts)
    edit_count = sum(1 if p == 'Edit from: ORIGINAL' else 0 for p in prompts)
    counted = Counter(prompts)
    assert len(prompts) == counted.total()

    trace(len(prompts), 'prompts/images read')
    trace(counted.total(), 'prompts/images counted')
    print('-' * 30)
    trace(vars_count, 'variations')
    trace(edit_count, 'edits')
    trace(len(prompts) - vars_count - edit_count, 'direct prompts/images')
    print('-' * 30)
    trace(len(counted), 'distinct prompts')
    print()
    for prompt, count in counted.most_common():
        trace(count, prompt)


if __name__ == '__main__':
    main()
