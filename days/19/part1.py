[workflows_str, parts_str] = open("input.txt").read().split("\n\n")

class Rule:
    def __init__(self, category, op, value, send_to):
        self.category = category
        self.op       = op
        self.value    = value
        self.send_to  = send_to

    @classmethod
    def default_rule(cls, send_to):
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

    rules.append(Rule.default_rule(rules_str[-1]))
    workflows[name] = rules

parts = []
for line in parts_str.strip().split("\n"):
    part = {}
    for ratings in line[1:-1].split(","):
        [category, value] = ratings.split("=")
        part[category] = int(value)

    parts.append(part)

def test_part_against_rule(part, rule):
    if rule.category == None:
        return True
    else:
        return rule.op(part[rule.category], rule.value)

def rate_part(part, send_to, workflows):
    if   send_to == "R": return False
    elif send_to == "A": return True

    for rule in workflows[send_to]:
        if test_part_against_rule(part, rule):
            return rate_part(part, rule.send_to, workflows)

sum = 0
for part in parts:
    if rate_part(part, "in", workflows):
        for key in part:
            sum += part[key]

print(sum)
