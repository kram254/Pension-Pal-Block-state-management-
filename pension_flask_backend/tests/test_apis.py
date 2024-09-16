import unittest
import json
from pension_flask_backend.app import create_app, db
from pension_flask_backend.app.models import Pension

class APITestCase(unittest.TestCase):
    def setUp(self):
        self.app = create_app('testing')
        self.client = self.app.test_client()

        with self.app.app_context():
            db.create_all()
            # Add a sample pension
            pension = Pension(
                scheme_name='Retirement Fund',
                contributions=5000.0,
                balance=25000.0,
                pension_type='Type A'
            )
            db.session.add(pension)
            db.session.commit()

    def tearDown(self):
        with self.app.app_context():
            db.session.remove()
            db.drop_all()

    def test_get_pensions(self):
        response = self.client.get('/api/pensions')
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertTrue(len(data) > 0)

    def test_get_pension(self):
        response = self.client.get('/api/pensions/1')
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertEqual(data['scheme_name'], 'Retirement Fund')

    def test_create_pension(self):
        new_pension = {
            'scheme_name': 'Health Fund',
            'contributions': 3000.0,
            'balance': 15000.0,
            'pension_type': 'Type B'
        }
        response = self.client.post('/api/pensions', data=json.dumps(new_pension),
                                    content_type='application/json')
        self.assertEqual(response.status_code, 201)
        data = json.loads(response.data)
        self.assertEqual(data['scheme_name'], 'Health Fund')

    def test_update_pension(self):
        update_data = {
            'balance': 30000.0
        }
        response = self.client.put('/api/pensions/1', data=json.dumps(update_data),
                                   content_type='application/json')
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertEqual(data['balance'], 30000.0)

    def test_delete_pension(self):
        response = self.client.delete('/api/pensions/1')
        self.assertEqual(response.status_code, 200)
        # Verify deletion
        response = self.client.get('/api/pensions/1')
        self.assertEqual(response.status_code, 404)

if __name__ == '__main__':
    unittest.main()