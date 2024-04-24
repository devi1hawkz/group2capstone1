import json

filename = "data.txt"


def get_input():
    quan = input("How many questions would you like to enter?: ")

    fn = open(filename, "w")
    counter = 0

    while counter < int(quan):
        q1 = input("Enter Question: ")
        fn.write(q1 + " \n")
        answer = input("Enter Correct Answer: ")

        fn.write(answer + ", ")
        print("Enter 3 possible correct answers")

        for i in range(3):
            panswer = input(str(i+1) + ". ")
            fn.write(panswer + ", ") if i<2 else fn.write(panswer + "\n")
        
        fn.write(answer + "\n")
        
        counter+=1


def convert_txt_to_json(txt_file):
    questions = []
    with open(txt_file, 'r') as file:
        lines = file.readlines()
        i = 0
        while i < len(lines):
            try:
                question_text = lines[i].strip()
                options = [opt.strip() for opt in lines[i+1].strip().split(',')]
                correct_answers = [answer.strip() for answer in lines[i+2].strip().split(',')]
                correct_option_indices = []
                for answer in correct_answers:
                    try:
                        correct_option_indices.append(options.index(answer))
                    except ValueError:
                        print(f"Answer '{answer}' not found in options for question '{question_text}'. Skipping question.")
                question = {
                    "type": "multiple_choice",
                    "text": question_text,
                    "options": options,
                    "correct_option": correct_option_indices
                }
                questions.append(question)
            except (IndexError, ValueError) as e:
                print(f"Skipping invalid question format at line {i+1}: {e}")
            i += 3
    json_data = {"questions": questions}
    return json_data


def save_json(data, json_file):
    with open(json_file, 'w') as file:
        json.dump(data, file, indent=4)

if __name__ == "__main__":
    txt_file = "data.txt"
    json_file = "user.json"

    # get_input()
    json_data = convert_txt_to_json(txt_file)
    save_json(json_data, json_file)
    print("Done")