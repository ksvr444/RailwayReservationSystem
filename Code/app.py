from flask import Flask,render_template,request
import os
import pymysql.cursors


app = Flask(__name__)

# Connect to the database
connection = pymysql.connect(host='rrs.ccsxo0vdgqdw.us-east-1.rds.amazonaws.com',
                             user='admin',
                             password='12345678',
                             db='RRS',
                             cursorclass=pymysql.cursors.DictCursor)

@app.route('/')
def index():
    routes = [{'Header': 'Retrieve all trains user booked to ',
               'Description': 'List something',
               'url': '/form/1'},
              {'Header': ' list of passengers travelling on a day ',
               'Description': '',
               'url': '/form/2'},
              {'Header': ' Get Passenger list between ages ',
               'Description': '',
               'url': '/form/3'}, 
              {'Header': ' Get Passenger count For all trains ',
               'Description': '',
               'url': '/4'},
              {'Header': ' Retrieve all passengers of a train ',
               'Description': '',
               'url': '/form/5'}, 
              {'Header': 'cancelling ticket to get waiting list person confirmed ',
               'Description': '',
               'url': '/form/6'}]
    return render_template('index.html',routes=enumerate(routes))



## Form 1


@app.route(f'/form/<int:route>')
def form1(route):
    try:
        ans =  render_template(f'{route}form.html')
    except :
        ans = render_template('404.html')
    return ans

@app.route('/1', methods=['POST'])
def form1response():
    print(request.form["firstname"])
    first_name = request.form.get("firstname")
    last_name = request.form.get("lastname")
    with connection.cursor() as cursor:
        sql = '''
        select Train.number, Train.name, Train.source, Train.destination, Booking.category, Booking.status
from Train, Booking, Passenger where Train.number= Booking.train_number and Booking.passenger_ssn= Passenger.ssn
and Passenger.firstname = "{firstname}" and Passenger.lastname = "{lastname}";
        '''.format(firstname=first_name, lastname=last_name)
        print(sql)
        cursor.execute(sql)
        result = cursor.fetchall()
       
        col_names = ["Train Number", "Train Name", "Source", "Destination", "Category", "Status"]
        values=[]
        for rows in result:
            values.append([x for x in rows.values()])
        print(values)
        print(col_names)
    cursor.close()
    return render_template('1.html', result=values, col_names=col_names)

@app.route('/2', methods=['POST'])
def form2response():
    sel_day = request.form.get("selected-day")
    print(sel_day)
    with connection.cursor() as cursor:
        sql ='''
        select P.firstname,
    P.lastname,
    B.train_number,
    B.category
    from Passenger as P, Availability as A, Booking as B where P.ssn = B.passenger_ssn
    and B.train_number = A.train_number
    and A.day='{sel_day}'
    and B.status = 'confirmed';'''.format(sel_day=sel_day)
        print(sql)
        cursor.execute(sql)
        result = cursor.fetchall()
        
        col_names = ["First Name", "Last Name", "Train Number", "Category"]
        values=[]
        for rows in result:
            values.append([x for x in rows.values()])
        print(values)
        print(col_names)
    cursor.close()
    return render_template('1.html', result=values, col_names=col_names)


@app.route('/3', methods=['POST'])
def form3response():
    minage = request.form.get("minage")
    maxage = request.form.get("maxage")
    with connection.cursor() as cursor:
        sql = '''
        select Train.name as Train_name,
    Train.number as Train_number,
    Train.source,
    Train.destination,
    CONCAT(Passenger.firstname," ",Passenger.lastname) as name,
    Passenger.address,
    Booking.category,
    Booking.status
    from Booking
    LEFT JOIN Train ON Train.number = Booking.train_number
    LEFT JOIN Passenger ON Passenger.ssn = Booking.passenger_ssn
    where DATE_FORMAT(NOW(), '%Y') - DATE_FORMAT(Passenger.bdate, '%Y') - (DATE_FORMAT(NOW(), '00-%m-%d') < DATE_FORMAT(Passenger.bdate, '00-%m-%d')) BETWEEN {minage} AND {maxage};
      '''.format(minage=minage, maxage=maxage)
        print(sql)
        cursor.execute(sql)
        result = cursor.fetchall()

        col_names = ["Train Name", "Train Number", "Source", "Destination", "Name", "Address", "Category", "Status"]
        values = []
        for rows in result:
            values.append([x for x in rows.values()])
        print(values)
    cursor.close()
    return render_template('1.html', result=values, col_names=col_names)


@app.route('/4', methods=['POST', 'GET'])
def form4response():
    with connection.cursor() as cursor:
        sql = '''
        SELECT t.name, count(b.train_number) as count from Train t left JOIN Booking b on t.number = b.train_number GROUP by t.name HAVING count(b.train_number) >=0;
       '''
        print(sql)
        cursor.execute(sql)
        result = cursor.fetchall()

        col_names = ["Train Name", "Count"]
        values = []
        for rows in result:
            values.append([x for x in rows.values()])
        print(values)
    cursor.close()
    return render_template('1.html', result=values, col_names=col_names)

@app.route('/5', methods=['POST', 'GET'])
def form5response():
    train_name = request.form.get("selected-train")
    with connection.cursor() as cursor:
        sql = '''
        select Passenger.firstname,
        Passenger.lastname,
        Passenger.address,
        Booking.category
        from Booking
        LEFT JOIN Train ON Train.number = Booking.train_number
        LEFT JOIN Passenger ON Passenger.ssn = Booking.passenger_ssn
        where Train.name = '{train_name}'
        and Booking.status = 'confirmed';
       '''.format(train_name=train_name)
        print(sql)
        cursor.execute(sql)
        result = cursor.fetchall()

        col_names = ["First Name", "Last Name", "Address", "Category"]
        values = []
        for rows in result:
            values.append([x for x in rows.values()])
        print(values)
    cursor.close()
    return render_template('1.html', result=values, col_names=col_names)


@app.route('/form/5', methods=['POST', 'GET'])
def form5():
    with connection.cursor() as cursor:
        sql = '''
        SELECT name from Train;
       '''
        cursor.execute(sql)
        result = cursor.fetchall()
        values = []
        for rows in result:
            values.append([x for x in rows.values()])
        print(values)
    cursor.close()
    return render_template('5form.html', trains=values)






## Form 2

@app.route('/2form')
def form2():
    return render_template('2form.html')


if __name__ == "__main__":
    app.run(debug=True, port=2000)


@app.route('/6', methods=['POST'])
def form6response():
    pass_ssn = request.form.get("ssn")
    train_num = request.form.get("train-num")
    with connection.cursor() as cursor:
        sql = ''' select * from Booking where passenger_ssn='{pass_ssn}' and train_number='{train_num}';
        '''.format(pass_ssn=pass_ssn, train_num=train_num)
        print(sql)
        cursor.execute(sql)
        result = cursor.fetchall()
        values = []
        
        for rows in result:
            values.append([x for x in rows.values()])
        print(values);
        
        
        ssn_res = []
        upd_res = []
        col_names = ["First Name", "Last Name", "Train Number", "Category", "SSN"]
        
        if not values:
            return render_template('6.html', result=upd_res, col_names=col_names, cancelled_pass="No records of passenger booking found")
        
        
        del_category = values[0][2]
        sql ='''
            delete from Booking where passenger_ssn='{pass_ssn}' and train_number='{train_num}';
            '''.format(pass_ssn=pass_ssn, train_num=train_num)
        cursor.execute(sql)
        print(sql)
        
        
        if values[0][3] == 'confirmed':
            sql = ''' select passenger_ssn from Booking where train_number='{train_num}' and status='waitlist' and category='{del_category}';
            '''.format(train_num=train_num, del_category=del_category)
            print(sql)
            cursor.execute(sql)
            result = cursor.fetchall()
            for rows in result:
                ssn_res.append([x for x in rows.values()])
            
            print("Printing ssn_res" +str(ssn_res))
            
            sql ='''
            update Booking set status='confirmed' where train_number='{train_num}' and status='waitlist' and category='{del_category}';
            '''.format(train_num=train_num, del_category=del_category)
            print(sql)
            cursor.execute(sql)
            
            if ssn_res:
                sql = '''select P.firstname,
                P.lastname,
                B.train_number,
                B.category,
                P.ssn
                from Passenger as P
                JOIN Booking as B ON P.ssn = B.passenger_ssn
                where P.ssn = '{pass_ssn}' and train_number='{train_num}';'''.format(pass_ssn=ssn_res[0][0], train_num=train_num)
                cursor.execute(sql)
                result = cursor.fetchall()
                for rows in result:
                    upd_res.append([x for x in rows.values()])
                print(upd_res)
            
            
            
    connection.commit()    
    cursor.close()
    return render_template('6.html', result=upd_res, col_names=col_names, waitlist_msg="Ticket is confirmed to the below waitlist passenger", cancelled_msg="Ticket Cancelled successfully")
    