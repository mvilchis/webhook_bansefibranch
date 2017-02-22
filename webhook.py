from flask import request, url_for
from flask_api import FlaskAPI, status, exceptions
from utils import *
import os
import ast
from flask import jsonify
app = FlaskAPI(__name__)
KEYS = ['street_a', 'street_b', 'locality']

@app.route("/", methods=['GET', 'POST'])
def get_nearest_bansefi():
    """
    List or create notes.
    """
    if request.method == 'POST':
        request_dic = request.form.to_dict()
        #Obtain values list of rapidpro post
        values_dic = request_dic['values']
        #Transform unicode to dictionary
        items = list(map(dict, ast.literal_eval(values_dic)))
        #We are search for tree items:
        final_dictionary = {key:'' for key in KEYS }
        for item in items:
           this_key = item['label']
           if this_key in KEYS:
               final_dictionary[this_key] = item['value']
        nearest_bansefi = get_basefi_reference(int(float(final_dictionary['locality'])),
                            final_dictionary['street_a'],
                            final_dictionary['street_b'])
        return jsonify({'nearest_bansefi':nearest_bansefi})

if __name__ == "__main__":
    #Cambiar ip a 0.0.0.0
    app.run(debug=False, host="0.0.0.0", port= int(os.getenv('WEBHOOK_PORT', 5000)))
