from collections import Counter
from json import load

VARIATION = 'Variation from: ORIGINAL'
EDIT = 'Edit from: ORIGINAL'
RULE = 34

def clean_prompt(prompt):
    return prompt.strip().replace('\n', ' ')

def trace(count, description):
    print(f'  {count:5,d}', description)

def main():
    with open('prompts.json', mode='r', encoding='utf8') as file:
        data = load(file)

    prompts = [clean_prompt(prompt) for prompt in data['prompts']]
    vars_count = sum(1 if p == VARIATION else 0 for p in prompts)
    edit_count = sum(1 if p == EDIT else 0 for p in prompts)

    counted = Counter(prompts)
    assert len(prompts) == counted.total()

    cluster_size_counts = dict()
    for prompt, count in counted.most_common():
        if prompt in (VARIATION, EDIT):
            continue
        cluster_size_counts[count] = cluster_size_counts.setdefault(count, 0) + 1

    distinct_prompts = 0
    for count in cluster_size_counts.values():
        distinct_prompts += count
    # Variations and edits don't count as distinct prompts.
    assert distinct_prompts == len(counted) - 2

    print('\n')
    trace(counted.total(), 'images')
    print('-' * RULE)
    trace(vars_count, 'variations')
    trace(edit_count, 'edits')
    trace(len(prompts) - vars_count - edit_count, 'directly prompted images')
    print('=' * RULE)
    trace(distinct_prompts, 'distinct prompts')
    print('-' * RULE)
    for cluster_size, count in cluster_size_counts.items():
        trace(count, f'cluster with {cluster_size} images')
    print('\n')

if __name__ == '__main__':
    main()
