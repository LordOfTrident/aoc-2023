import copy, math, functools as ft

[workflows_str, parts_str] = open("input.txt").read().split("\n\n")

class Rule:
    def __init__(self, category, op, value, send_to):
        self.category = category
        self.op       = op
        self.value    = value
        self.send_to  = send_to

    @classmethod
    def defaultRule(cls, send_to):
        return cls(None, None, None, send_to)

workflows = {}
for line in workflows_str.strip().split("\n"):
    [name, content] = line[0:-1].split("{")
    rules = []

    rules_str = content.split(",")
    for rule in rules_str[0:-1]:
        [cond, send_to] = rule.split(":")
        op = (lambda a, b: a > b) if cond[1] == ">" else (lambda a, b: a < b)
        rules.append(Rule(cond[0], op, int(cond[2:]), send_to))

    rules.append(Rule.defaultRule(rules_str[-1]))
    workflows[name] = rules

parts = []
for line in parts_str.strip().split("\n"):
    part = {}
    for ratings in line[1:-1].split(","):
        [category, value] = ratings.split("=")
        part[category] = int(value)

    parts.append(part)

def recurse(workflows, send_to, rangs):
    if   send_to == 'R': return 0
    elif send_to == 'A': return math.prod([len(rangs[category]) for category in rangs])

    sum = 0
    for rule in workflows[send_to]:
        if rule.category == None:
            sum += recurse(workflows, rule.send_to, rangs)
            break

        rang     = rangs[rule.category]
        filtered = list(filter(lambda x: rule.op(x, rule.value), rang))

        if filtered != []:
            rangs_copy = rangs.copy()
            rangs_copy[rule.category] = filtered
            sum += recurse(workflows, rule.send_to, rangs_copy)

        rangs[rule.category] = list(x for x in rang if not rule.op(x, rule.value))

    return sum

print(recurse(workflows, "in", {
    "x": range(1, 4001),
    "m": range(1, 4001),
    "a": range(1, 4001),
    "s": range(1, 4001),
}))
