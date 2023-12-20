from enum import Enum

ModuleType = Enum("ModuleType", ["FlipFlop", "Conjunction", "Broadcaster"])

class Module:
    def __init__(self, type, sends_to):
        self.type     = type
        self.sends_to = sends_to

class FlipFlop(Module):
    def __init__(self, sends_to):
        super().__init__(ModuleType.FlipFlop, sends_to)
        self.state = 0

class Conjunction(Module):
    def __init__(self, sends_to):
        super().__init__(ModuleType.Conjunction, sends_to)
        self.inputs = {}

class Broadcaster(Module):
    def __init__(self, sends_to):
        super().__init__(ModuleType.Broadcaster, sends_to)

modules = {}
for line in open("input.txt"):
    [id, sends_to_str] = line.strip().split(" -> ")
    sends_to = sends_to_str.split(", ")

    name   = id[1:]
    module = None
    if   id[0] == "%": module = FlipFlop(sends_to)
    elif id[0] == "&": module = Conjunction(sends_to)
    elif id    == "broadcaster":
        module = Broadcaster(sends_to)
        name = id

    modules[name] = module

def conjunction_find_senders(modules, conjunction_name):
    for name, module in modules.items():
        if name != conjunction_name and conjunction_name in module.sends_to:
            modules[conjunction_name].inputs[name] = 0

for name, module in modules.items():
    if module.type == ModuleType.Conjunction:
        conjunction_find_senders(modules, name)

def broadcast(modules):
    queue = [("button", "broadcaster", 0)]
    count = [1, 0]
    while queue != []:
        (sender, reciever, recieved) = queue.pop(0)

        to_send = None
        if modules[reciever].type == ModuleType.Broadcaster:
            to_send = recieved
        elif modules[reciever].type == ModuleType.FlipFlop:
            if recieved == 0:
                modules[reciever].state = 1 - modules[reciever].state
                to_send = modules[reciever].state
        elif modules[reciever].type == ModuleType.Conjunction:
            modules[reciever].inputs[sender] = recieved

            to_send = 0 if list(modules[reciever].inputs.values()).count(0) == 0 else 1

        if to_send == None:
            continue

        for to in modules[reciever].sends_to:
            if to in modules:
                queue.append((reciever, to, to_send))

        count[to_send] += len(modules[reciever].sends_to)

    return count

total_lows  = 0
total_highs = 0

for _ in range(1000):
    [lows, highs] = broadcast(modules)
    total_lows  += lows
    total_highs += highs

print(total_lows * total_highs)
