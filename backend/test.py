import itertools


class TreeNode:

    def __init__(self, location):
        self._location = location
        self._children = []

    def add_child(self, child):
        self._children.append(child)

    def get_children(self):
        return self._children


def generate_tree(start, end, num_stops, wish_list):
    links = wish_list
    if len(wish_list) < num_stops:
        links += ['anywhere'] * (num_stops - len(wish_list))

    perms = list(itertools.permutations(links))
    perms = map(lambda p: [start] + list(p) + [end], perms)

    all_pairs = list()
    for idx in range(len(perms[0]) - 1):
        depth_pairs = set()  # TODO: set() or list()
        for perm in perms:
            depth_pairs.add((perm[idx], perm[idx + 1]))
        all_pairs.append(depth_pairs)


def main():
    generate_tree('100', '200', 3, ['150'])


if __name__ == "__main__":
    main()
